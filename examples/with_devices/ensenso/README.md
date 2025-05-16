# Use Ensenso Camera with ROS1 + Docker environment

## Prerequisite
- Ensenso SDK

## Compatibility
- ensenso-sdk-4.0.1502-x64.deb

## Installation
- Place ensenso SDK here (devices/ensenso/ensenso-sdk-*.deb)
- Clone Ensenso ROS Driver package on catkin_ws. `git@github.com:ensenso/ros_driver.git`
- Add `devices` mount to `docker-compose.yml`

## Run
1. Run services
```sh
docker compose exec ensenso bash -ic "cd catkin_ws && rosrun ensenso_camera ensenso_camera_node"
docker compose exec ensenso bash -ic "cd catkin_ws && rosrun ensenso_camera request_data"
```

2. Listen topic on Rviz
- /

## Run(Simulator)
TODO:

## Tested List
- ensenso/ros_driver has been built
- 