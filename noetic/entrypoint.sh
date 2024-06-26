grep -F "source /opt/ros/noetic/setup.bash" ~/.bashrc ||
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

grep -F "source ~/catkin_ws/devel/setup.bash" ~/.bashrc ||
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc