# GLITCH Docker Compose Usage Guide

## 📁 Project Structure

Create this directory structure:

```
your-project/
├── docker-compose.yml
├── iac-scripts/          # Your IaC files go here
│   ├── playbooks/
│   ├── manifests/
│   ├── terraform/
│   └── cookbooks/
├── results/              # Analysis results output here
├── configs/              # Custom configuration files (optional)
│   ├── custom-ansible.yml
│   └── custom-puppet.yml
└── README.md
```

## 🚀 Quick Start

```bash
# Create directories
mkdir -p iac-scripts results configs

# Copy your IaC files
cp -r /path/to/your/ansible/* iac-scripts/
cp -r /path/to/your/puppet/* iac-scripts/
```

## 🔍 Analysis Commands

### General Analysis
```bash
# Show help
docker-compose run --rm glitch --help

# Analyze all files (you specify the tech)
docker-compose run --rm glitch --tech ansible --csv /workspace
```

### Technology-Specific Analysis
```bash
# Ansible analysis
docker-compose run --rm glitch-ansible

# Puppet analysis  
docker-compose run --rm glitch-puppet

# Terraform analysis
docker-compose run --rm glitch-terraform

# Chef analysis (limited support)
docker-compose run --rm glitch-chef
```

### Interactive Mode
```bash
# Interactive shell
docker-compose run --rm glitch-interactive

# Inside the container:
glitch --tech ansible /workspace
glitch --tech puppet --csv /workspace > /results/puppet-analysis.csv
exit
```

### Custom Commands
```bash
# With custom config
docker-compose run --rm glitch --tech ansible --config /custom-configs/custom-ansible.yml --csv /workspace

# With module analysis
docker-compose run --rm glitch --tech terraform --module --csv /workspace

# Pretty table output (no CSV)
docker-compose run --rm glitch --tech puppet /workspace
```

## 📊 Output Examples

### Save Results to Host
```bash
# Save Ansible analysis to results directory
docker-compose run --rm glitch-ansible > results/ansible-$(date +%Y%m%d).csv

# Save Puppet analysis
docker-compose run --rm glitch-puppet > results/puppet-analysis.csv
```

### Multiple Technology Analysis
```bash
# Analyze all technologies
docker-compose run --rm glitch-ansible > results/ansible.csv &
docker-compose run --rm glitch-puppet > results/puppet.csv &
docker-compose run --rm glitch-terraform > results/terraform.csv &
wait
echo "All analyses complete!"
```

## ⚙️ Configuration

### Using Custom Configs
Place custom configuration files in the `configs/` directory:

```bash
# Create custom Ansible config
cat > configs/strict-ansible.yml << EOF
rules:
  security:
    - hard_coded_secret: true
    - weak_cryptography: true
  design:
    - long_statement: true
    - complex_expression: true
EOF

# Use it
docker-compose run --rm glitch --tech ansible --config /custom-configs/strict-ansible.yml --csv /workspace
```

### Environment Variables
Add to `docker-compose.yml`:

```yaml
services:
  glitch:
    environment:
      - GLITCH_LOG_LEVEL=DEBUG
      - GLITCH_OUTPUT_FORMAT=csv
```

## 🛠️ Advanced Usage

### Background Analysis
```bash
# Run analysis in background
docker-compose up -d glitch-ansible
docker-compose up -d glitch-puppet

# Check logs
docker-compose logs glitch-ansible
docker-compose logs glitch-puppet

# Stop services
docker-compose down
```

### Batch Processing
```bash
#!/bin/bash
# batch-analyze.sh

technologies=("ansible" "puppet" "terraform")
timestamp=$(date +%Y%m%d_%H%M%S)

for tech in "${technologies[@]}"; do
    echo "Analyzing $tech..."
    docker-compose run --rm glitch --tech $tech --csv /workspace > "results/${tech}_${timestamp}.csv"
    echo "$tech analysis complete"
done

echo "All analyses finished. Results in results/ directory."
```

### Cleanup
```bash
# Stop all containers
docker-compose down

# Remove all containers and volumes
docker-compose down -v

# Clean up Docker system
docker system prune -f
```

## 📋 Service Descriptions

| Service | Purpose | Command Override |
|---------|---------|------------------|
| `glitch` | General analysis | Yes, specify --tech |
| `glitch-interactive` | Interactive shell | Use bash commands |
| `glitch-ansible` | Ansible-specific | Fixed to Ansible |
| `glitch-puppet` | Puppet-specific | Fixed to Puppet |
| `glitch-terraform` | Terraform-specific | Fixed to Terraform |
| `glitch-chef` | Chef-specific | Fixed to Chef |

## 🔧 Troubleshooting

### Common Issues

**Permission Errors**
```bash
sudo chown -R $USER:$USER iac-scripts/ results/
chmod -R 755 iac-scripts/ results/
```

**No Files Found**
```bash
# Check mounted files
docker-compose run --rm glitch ls -la /workspace
```

**Container Won't Start**
```bash
# Check Docker Compose logs
docker-compose logs glitch

# Recreate containers
docker-compose down
docker-compose pull
docker-compose up --force-recreate
```

### Debug Mode
```bash
# Run with debug output
docker-compose run --rm glitch --tech ansible --csv /workspace --verbose
```