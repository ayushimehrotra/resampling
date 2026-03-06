export RM_INTERP_REPO="/workspace/gcm-interp"
export HF_TOKEN="<HF_TOKEN>"
echo "RM_INTERP_REPO is $RM_INTERP_REPO"

declare -a pairs=(
  "harmful-long_harmless"
)
declare -A eval_datasets

algos=("atp")
model_id="Qwen/Qwen1.5-14B-Chat"
model_name="Qwen1.5-14B-Chat"
device="cuda:0"

for pair in "${pairs[@]}"; do
    IFS='_' read -r source base <<< "$pair"
  
  for algo in "${algos[@]}"; do
      pip install nnsight==0.4.11
      python run.py --model_id "$model_id" \
                    --batch_size 1 \
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
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/harmful-single/harmless-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/harmful-single/harmful-single-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/harmful-single/harmless-desired-all.jsonl"

      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --eval_model \
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/harmful-single/harmless-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/harmful-long/harmful-long-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/harmful-long/harmless-desired-all.jsonl"

      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --eval_model \
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/harmful-long/harmless-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/harmful-single/harmful-single-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/harmful-single/harmless-desired-all.jsonl"

      python run.py --model_id "$model_id" \
                    --batch_size 4 \
                    --patch_algo "$algo" \
                    --source $source \
                    --base  $base \
                    --device "$device" \
                    --eval_model \
                    --eval_test  "/workspace/gcm-interp/data/${model_name}/harmful-long/harmless-test.jsonl"\
                    --steering \
                    --ablation steer \
                    --steering_add_path  "/workspace/gcm-interp/data/${model_name}/harmful-long/harmful-long-desired-all.jsonl" \
                    --steering_sub_path "/workspace/gcm-interp/data/${model_name}/harmful-long/harmless-desired-all.jsonl"
  done
done
