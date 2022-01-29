# aws-lambda-layer-pandas

*BUILT THIS REPO AND THEN WHILE MAKING A PR TO BE INCLUDED ON `awesome-layers` repo
I FOUND OUT ABOUT https://github.com/keithrozario/Klayers
SO THIS IS DEPRECATED IMMEDIATELY 1 HOUR AFTER BIRTH :D*


AWS Lambda layer providing pandas and numpy.

ARN of public AWS lambda layer: `arn:aws:lambda:us-east-1:974668457921:layer:Pandas:1`

TODO

- Request to link from https://github.com/mthenw/awesome-layers


## Usage

To publish the lambda layer publicly:

```
docker build -t wesa-aws-lambda-layer-python-pandas .
export AWS_ACCESS_KEY_ID=abc
export AWS_SECRET_ACCESS_KEY=abc
docker run --rm -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY wesa-aws-lambda-layer-python-pandas
```

This will output something along

```
Uploading layer.zip to s3://aws-lambda-layer-pandas/layer.zip
upload: ./layer.zip to s3://aws-lambda-layer-pandas/layer.zip    
published python3.x layer version 2 to us-east-1
Setting public permissions for python3.x layer version 2 in us-east-1
{
    "Statement": "{
        \"Sid\":\"public\",\"Effect\":\"Allow\",\"Principal\":\"*\",\"Action\":\"lambda:GetLayerVersion\",
        \"Resource\":\"arn:aws:lambda:us-east-1:974668457921:layer:Pandas:2\"
    }",
    "RevisionId": "69301063-28b7-40e2-b0e9-9a95ab6a725f"
}
Public permissions set for python3.x Layer version 2 in region us-east-1
```

where the `Resource` is the public ARN


## LICENSE

Check LICENSE file


## Dev notes

Naming follows https://github.com/aws-samples/aws-lambda-layer-kubectl

Dockerfile inspired by several other github repos.
Links inline in the Dockerfile itself.
