# This is the example script to run distributed xgboost on AWS.
# Change the following two lines for configuration

CONFIG_FILE=$1
NAME=$2
BUCKET=$3
#data=s3://${BUCKET}/run3/1layer/ATSE1036_BASIC_ALL_SVMF_0812G/#dtrain.cache\
# submit the job to YARN
# 20g * 4 * 2 < M-30
time ../../dmlc-core/tracker/dmlc-submit --cluster=yarn --num-workers=10 --worker-cores=2 --server-memory=20g --worker-memory=20g\
    ../../xgboost ${CONFIG_FILE} nthread=4\
    data=s3://${BUCKET}/run3/1layer/ATSE1036_BASIC_ALL_SVMF_0812G/#dtrain.cache\
    eval[vmalicioustrain]=s3://${BUCKET}/run3/data/run2verticnormal/#test.cache1\
    eval[vnomraltrain]=s3://${BUCKET}/run3/data/run2verticmalware/#test.cache1\
    model_dir=s3://${BUCKET}/run3/test1/${NAME}/  2>&1 | tee ${NAME}.log

cat ${CONFIG_FILE} >>  ${NAME}.log
cat $0 >> ${NAME}.log
aws s3 cp --acl bucket-owner-full-control  ${NAME}.log  s3://${BUCKET}/run3/tmodel/${NAME}.log
