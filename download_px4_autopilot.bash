pip3 install jsonschema

cd /home/ubuntu
git clone https://github.com/PX4/PX4-Autopilot --recursive
cd PX4-Autopilot
git checkout v1.14.0 # tag at release/1.14.0 branch
git submodule update --recursive
git submodule update --init --recursive

cd /home/ubuntu
git clone https://github.com/mavlink/mavlink.git --recursive
PYTHONPATH=/home/user/mavlink
