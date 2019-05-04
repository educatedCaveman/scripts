aticonfig --odgt | grep "Temperature" | awk '{printf "%2d", $5}'
