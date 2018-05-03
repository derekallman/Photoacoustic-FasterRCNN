#!/usr/bin/env python

# --------------------------------------------------------
# Faster R-CNN
# Copyright (c) 2015 Microsoft
# Licensed under The MIT License [see LICENSE for details]
# Written by Ross Girshick
# --------------------------------------------------------

"""
Demo script showing detections in sample images.

See README.md for installation instructions before running.
"""

import _init_paths
from fast_rcnn.config import cfg
from fast_rcnn.test import im_detect
from fast_rcnn.nms_wrapper import nms
from utils.timer import Timer
from os.path import splitext
import matplotlib.pyplot as plt
import numpy as np
import scipy.io as sio
import caffe, os, sys, cv2
import argparse

CLASSES = ('__background__',
           'source','artifact')

NETS = {'vgg16': ('VGG16',
                  'VGG16_faster_rcnn_final.caffemodel')}

TRAIN = 'L3-8_s1_r1'
DATASET = 'steak'


def vis_detections(im, class_name, dets, name, thresh=0.5):
    """Draw detected bounding boxes."""
    inds = np.where(dets[:, -1] >= thresh)[0]
    if len(inds) == 0:
        return

    im = im[:, :, (2, 1, 0)]
    fig, ax = plt.subplots(figsize=(12, 12))
    ax.imshow(im, aspect='auto')
    for i in inds:
        bbox = dets[i, :4]
        score = dets[i, -1]

        ax.add_patch(
            plt.Rectangle((bbox[0], bbox[1]),
                          bbox[2] - bbox[0],
                          bbox[3] - bbox[1], fill=False,
                          edgecolor='red', linewidth=3.5)
            )
        ax.text(bbox[0], bbox[1] - 2,
                '{:s} {:.3f}'.format(class_name, score),
                bbox=dict(facecolor='blue', alpha=0.5),
                fontsize=14, color='white')

    ax.set_title(('{} detections with '
                  'p({} | box) >= {:.1f}').format(class_name, class_name,
                                                  thresh),
                  fontsize=14)
    plt.axis('off')
    ax.axis('image')
    plt.tight_layout()
    #ax.set_aspect(3/4,adjustable='box')
    plt.draw()
    imdir = "../paimdb/evaluation/experimental/" + DATASET + "/cnn_output/" + TRAIN + "/box_ims/"
    if not os.path.exists(imdir):
        os.makedirs(imdir)
    plt.savefig(imdir + "/" + splitext(name)[0] + "_" + class_name + ".png", bbox_inches="tight")
def demo(net, image_name):
    """Detect object classes in an image using pre-computed object proposals."""

    # Load the demo image
    im_file = os.path.join(cfg.DATA_DIR, 
        'paimdb/evaluation/experimental/' + DATASET + '/Rf_data', image_name)
    im = cv2.imread(im_file)
    print(im.shape)
    # Detect all object classes and regress object bounds
    timer = Timer()
    timer.tic()
    scores, boxes = im_detect(net, im)
    timer.toc()
    print ('Detection took {:.3f}s for '
           '{:d} object proposals').format(timer.total_time, boxes.shape[0])

    # Visualize detections for each class
    CONF_THRESH = 0.458
    NMS_THRESH = 0.3
    #for cls_ind, cls in enumerate(CLASSES[1:]):
    cls_ind = 0
    cls = 'source'
    cls_ind += 1 # because we skipped background
    print(cls)
    cls_boxes = boxes[:, 4*cls_ind:4*(cls_ind + 1)]
    cls_scores = scores[:, cls_ind]
    dets = np.hstack((cls_boxes,
                    cls_scores[:, np.newaxis])).astype(np.float32)
    keep = nms(dets, NMS_THRESH)
    dets = dets[keep, :]
    vis_detections(im, cls, dets, image_name, thresh=CONF_THRESH)
    corr_dets = dets[dets[:,4]>CONF_THRESH]
    detdir = "../paimdb/evaluation/experimental/" + DATASET + "/cnn_output/" + TRAIN + "/dets/"
    if not os.path.exists(detdir):
        os.makedirs(detdir)
    np.savetxt(detdir + "/" + splitext(image_name)[0] + "_" + cls + ".csv", corr_dets, delimiter=",")

        #print(corr_dets)
        #print((corr_dets[:,0]+corr_dets[:,2])/2)
        #print((corr_dets[:,1]+corr_dets[:,3])/2)

def parse_args():
    """Parse input arguments."""
    parser = argparse.ArgumentParser(description='Faster R-CNN demo')
    parser.add_argument('--gpu', dest='gpu_id', help='GPU device id to use [0]',
                        default=0, type=int)
    parser.add_argument('--cpu', dest='cpu_mode',
                        help='Use CPU mode (overrides --gpu)',
                        action='store_true')
    parser.add_argument('--net', dest='demo_net', help='Network to use [vgg16]',
                        choices=NETS.keys(), default='vgg16')

    args = parser.parse_args()

    return args

if __name__ == '__main__':
    cfg.TEST.HAS_RPN = True  # Use RPN for proposals

    args = parse_args()

    prototxt = os.path.join(cfg.MODELS_DIR, NETS[args.demo_net][0],
                            'faster_rcnn_end2end', 'test.prototxt')

    
    caffemodel = os.path.join('output', 'faster_rcnn_end2end',
                              'paimdb_' + TRAIN + '_train','vgg16_faster_rcnn_iter_100000.caffemodel')

    if not os.path.isfile(caffemodel):
        raise IOError(('{:s} not found.\nDid you run ./data/script/'
                       'fetch_faster_rcnn_models.sh?').format(caffemodel))

    if args.cpu_mode:
        caffe.set_mode_cpu()
    else:
        caffe.set_mode_gpu()
        caffe.set_device(args.gpu_id)
        cfg.GPU_ID = args.gpu_id
    net = caffe.Net(prototxt, caffemodel, caffe.TEST)

    print '\n\nLoaded network {:s}'.format(caffemodel)

    # Warmup on a dummy image
    im = 128 * np.ones((300, 500, 3), dtype=np.uint8)
    for i in xrange(2):
        _, _= im_detect(net, im)

    im_names = []
    for i in range(16,-1, -1):
        im_names.append("RF_data_output{}.png".format(i+1))
    print(im_names)
    for im_name in im_names:
        print '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
        print 'Demo for data/demo/{}'.format(im_name)
        demo(net, im_name)

    plt.show()
