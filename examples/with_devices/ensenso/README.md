# Use Ensenso Camera with ROS1 + Docker environment

## Prerequisite
- Ensenso SDK

## Compatibility
- ensenso-sdk-4.0.1502-x64.deb

## Installation
- Place ensenso SDK here (devices/ensenso/ensenso-sdk-*.deb)
- Clone Ensenso ROS Driver package on catkin_ws. `https://github.com/ensenso/ros_driver.git`

## Run
0. (Optional) Open NxView
```sh
docker compose exec ensenso bash -ic "nxView"
```

1. Run services
```sh
docker compose exec ensenso bash -ic "cd catkin_ws && rosrun ensenso_camera ensenso_camera_node"
docker compose exec ensenso bash -ic "cd catkin_ws && rosrun ensenso_camera request_data"
```

2. Listen topics on Rviz
- /point_cloud
- /raw/left/image
- /raw/right/image
- /disparity_map

## Run(Simulator)
TODO:

## Tested List
- ensenso/ros_driver has been built
- 

## Troubles
- Ensenso カメラを接続した状態だと Linux Mint がブートできない（メーカーロゴ画面で停止する）
- `rosrun ensenso_camera ensenso_camera_node`でカメラが見つからない場合は、シリアル番号を手動設定してから実行する。
    `rosparam set /ensenso_camera_node/serial "123456"`
    シリアル No は NxView で確認する。
- Rvizで`/point_cloud`トピックを購読するとframeエラー
    - とりあえずGlobal OptionsのFixed Frameを`optical_frame_[serialNo]`に設定すると見れる