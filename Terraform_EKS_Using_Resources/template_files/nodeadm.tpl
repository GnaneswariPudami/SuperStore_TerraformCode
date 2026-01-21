MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="BOUNDARY"

--BOUNDARY
Content-Type: text/x-shellscript;

#!/bin/bash
set -o xtrace
echo "CLuster Name: ${cluster_name}"
echo "Cluster Endpoint: ${cluster_endpoint}"
echo "Cluster CA: ${cluster_ca}"
echo "Service CIDR: ${service_cidr}"
echo "Environment: ${environment}"

--BOUNDARY
Content-Type: application/node.eks.aws

---
apiVersion: node.eks.aws/v1alpha1
kind: NodeConfig
spec:
  cluster:
    name: ${cluster_name}
    apiServerEndpoint: ${cluster_endpoint}
    certificateAuthority: ${cluster_ca}
    cidr: ${service_cidr}
  kubelet:
    config:
      labels:
        node.kubernetes.io/environment: ${environment}
        node.kubernetes.io/role: worker

--BOUNDARY
Content-Type: text/x-shellscript;
  
#!/bin/bash
set -o xtrace

# Update system packages
yum update -y

# Install ssm agent
echo "Detected Amazon Linux. Installing SSM Agent..."
yum install -y amazon-ssm-agent
systemctl enable amazon-ssm-agent
systemctl start amazon-ssm-agent

systemctl status amazon-ssm-agent

# Enable and start kubelet
systemctl enable kubelet
systemctl start kubelet
  
  
--BOUNDARY--