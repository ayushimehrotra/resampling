export RM_INTERP_REPO="/workspace/gcm-interp"
export HF_TOKEN="<HF_TOKEN>"
echo "RM_INTERP_REPO is $RM_INTERP_REPO"

declare -a pairs=(
  "verse-single_prose"
)
declare -A eval_datasets

algos=("atp")
model_id="upstage/SOLAR-10.7B-Instruct-v1.0"
model_name="SOLAR-10.7B-Instruct-v1.0"
device="cuda:0"

for pair in "${pairs[@]}"; do
    IFS='_' read -r source base <<< "$pair"
  
  for algo in "${algos[@]}"; do
      pip install nnsight==0.4.11
      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --patch_model
      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --eval_model \
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/verse-single/prose-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/verse-single/verse-single-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/verse-single/prose-desired-all.jsonl"

      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --eval_model \
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/verse-single/prose-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/verse-long/verse-long-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/verse-long/prose-desired-all.jsonl"

      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --eval_model \
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/verse-long/prose-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/verse-single/verse-single-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/verse-single/prose-desired-all.jsonl"

      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --eval_model \
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/verse-long/prose-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/verse-long/verse-long-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/verse-long/prose-desired-all.jsonl"
  done
done
