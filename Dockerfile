# https://github.com/lambci/docker-lambda
FROM lambci/lambda:build-python3.7

ENV AWS_DEFAULT_REGION eu-central-1
ENV region eu-central-1
ENV bucket_name wesa-aws-lambda-layer-python-pandas

# https://github.com/clerk67/numpy-layer/blob/master/Dockerfile
#
# last line of find ... from
# https://github.com/iopipe/iopipe-python/blob/master/publish-layers.sh
# Removed matplotlib because otherwise the lambda layer will exceed the max of around 260MB
RUN pip install --upgrade pip && \
    pip install -t python/lib/python3.7/site-packages/ google-api-python-client google-auth pandas numpy PyYAML Xlrd openpyxl && \
    find python -name '__pycache__' -exec rm -fr {} +
RUN zip -ry9 layer.zip python

# https://github.com/mattmcclean/pandas-lambda-layer/blob/master/build.sh
# RUN aws lambda publish-layer-version --layer-name ${LAYER_NAME} --zip-file fileb://layer.zip --compatible-runtimes $COMPATIBLE_RUNTIMES

# https://github.com/iopipe/iopipe-python/blob/master/publish-layers.sh
CMD export region=${region} \
    && \
    export PY3X_DIST=layer.zip \
    && \
    export py3x_s3key=layer.zip \
    && \
    echo "Uploading ${PY3X_DIST} to s3://${bucket_name}/${py3x_s3key}" \
    && \
    aws --region $region s3 cp $PY3X_DIST "s3://${bucket_name}/${py3x_s3key}" \
    && \
    py3x_version=$(aws lambda publish-layer-version \
        --layer-name Pandas \
        --content "S3Bucket=${bucket_name},S3Key=${py3x_s3key}" \
        --description "Pandas Layer for Python 3.7" \
        --compatible-runtimes python3.7 \
        --license-info "Apache 2.0" \
        --region $region \
        --output text \
        --query Version) \
    && \
    echo "published python3.x layer version ${py3x_version} to ${region}" \
    && \
    echo "Setting permissions for python3.x layer version ${py3x_version} in ${region}" \
    && \
    aws lambda add-layer-version-permission \
      --layer-name Pandas \
      --version-number $py3x_version \
      --statement-id public \
      --action lambda:GetLayerVersion \
      --principal "719747043315" \
      --region $region \
    && \
    echo "Permissions set for python3.x Layer version ${py3x_version} in region ${region}"
