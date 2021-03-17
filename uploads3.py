import boto3
import os
import sys

#s3 = boto3.client(
#    's3',
#    aws_access_key_id='###AWS_ACCESS_KEY###',
#    aws_secret_access_key='###AWS_SECRET_KEY###'
#)


s3 = boto3.client('s3')
searchpath=sys.argv[1]
#print(sys.argv[1])

for root,d_names,f_names in os.walk(searchpath):
    for f in f_names:
        folder=os.path.realpath(root).split('/')
        s3path=folder[len(folder)-2] + '/' + folder[len(folder)-1] + '/' + f
        #s3.upload_file('windows.version', 'hiaas-vmimage-dev', 'windows.version')
        print(s3path)
        file=root + '/' + f
        s3.upload_file(file, 'hiaas-vmimage-dev', s3path)
        #print(file)
        #print(f)
