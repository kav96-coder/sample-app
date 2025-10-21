#!/bin/bash
apt update -y
apt install -y openjdk-11-jdk wget gnupg
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
apt update -y
apt install -y jenkins
systemctl enable jenkins
systemctl start jenkins

#Docker
# --- 1️⃣ Update System ---
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# --- 2️⃣ Create Keyring Directory ---
sudo mkdir -p /etc/apt/keyrings

# --- 3️⃣ Add Docker’s Official GPG Key ---
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# --- 4️⃣ Set Correct Permissions ---
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# --- 5️⃣ Add Docker APT Repository ---
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# --- 6️⃣ Update Package Index ---
sudo apt-get update -y

# --- 7️⃣ Install Docker Engine + Plugins ---
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# --- 8️⃣ Enable and Start Docker ---
sudo systemctl enable docker
sudo systemctl start docker
sudo systemctl status docker --no-pager

# --- 9️⃣ Add Jenkins User to Docker Group ---
sudo usermod -aG docker jenkins

# --- 🔟 Verify Docker Installation ---
docker --version
sudo docker run hello-world
