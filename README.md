# Installation

## Java JDK 8
```
sudo apt-get update 
sudo apt-get install openjdk-8-jdk -y
sudo update-alternatives --config java # Select JDK 8
```


# URSim environment
```
docker run --rm -it -p 5900:5900 -p 6080:6080 --name ursim -v ~/src:/opt/src universalrobots/ursim_e-series
```

```
docker exec -it ursim bash
```