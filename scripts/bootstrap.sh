# bootstrap script for EMR
sudo yum install -y git
python3 -m pip install boto3
sudo su - hadoop -c 'cd /home/hadoop && git clone https://github.com/eggressive/mastering-emr.git'