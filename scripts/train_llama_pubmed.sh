#!/bin/bash

export CUDA_VISIBLE_DEVICES=2,3
export BNB_CUDA_VERSION=117

name=pubmed-7b

output=snap/$name

PYTHONPATH=$PYTHONPATH:./llama_pubmed_src \
python -m torch.distributed.launch \
    --nproc_per_node=$1 \
    --master_port 12321 \
    llama_pubmed_src/pretrain.py \
        --distributed --multiGPU \
        --seed 42 \
	--gradient_accumulation_steps 8 \
        --train PubMed \
        --valid PubMed \
        --batch_size 20 \
        --optim adamw \
        --warmup_ratio 0.05 \
        --num_workers 2 \
        --clip_grad_norm 1.0 \
        --losses 'link,classification' \
        --backbone './7B' \
        --output $output ${@:2} \
        --epoch 2 \
	--weight_decay 0 \
        --max_text_length 512 \
        --gen_max_length 64 \
	--lr 0.00008
