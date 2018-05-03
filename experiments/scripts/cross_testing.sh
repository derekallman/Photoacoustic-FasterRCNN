#!/bin/bash
# Usage:
# ./experiments/scripts/faster_rcnn_end2end.sh GPU NET DATASET [options args to {train,test}_net.py]
# DATASET is either pascal_voc or coco.
#
# Example:
# ./experiments/scripts/faster_rcnn_end2end.sh 0 VGG_CNN_M_1024 pascal_voc \
#   --set EXP_DIR foobar RNG_SEED 42 TRAIN.SCALES "[400, 500, 600, 700]"

set -x
set -e

export PYTHONUNBUFFERED="True"

GPU_ID=$1
NET=$2
NET_lc=${NET,,}
DATASET=$3

array=( $@ )
len=${#array[@]}
EXTRA_ARGS=${array[@]:3:$len}
EXTRA_ARGS_SLUG=${EXTRA_ARGS// /_}

PT_DIR="pascal_voc"

for i in $(seq 1 10);
do
  for j in $(seq 1 1);
    do
      TRAIN_IMDB="paimdb_s${i}r1_train"
      TEST_IMDB="paimdb_s${j}r1_test"
      echo TEST_IMDB

      time ./tools/test_net.py --gpu ${GPU_ID} \
        --def models/${PT_DIR}/${NET}/faster_rcnn_end2end/test.prototxt \
        --net output/faster_rcnn_end2end/${TRAIN_IMDB}/vgg16_faster_rcnn_iter_100000.caffemodel \
        --imdb ${TEST_IMDB} \
        --cfg experiments/cfgs/faster_rcnn_end2end.yml \
        ${EXTRA_ARGS}
  done
done