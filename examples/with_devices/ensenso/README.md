# Use Ensenso Camera with ROS1 + Docker environment

## Prerequisite
- Ensenso SDK

## Compatibility
- ensenso-sdk-4.0.1502-x64.deb

## Installation
- Place ensenso SDK here (devices/ensenso/ensenso-sdk-*.deb)

## Run
```sh
docker compose exec ensenso bash -ic "cd catkin_ws && rosrun ensenso_camera ensenso_camera_node"
```

## Run(Simulator)
TODO:

## Tested List
- ensenso/ros_driver has been built
- 