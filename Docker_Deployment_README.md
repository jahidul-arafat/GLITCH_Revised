# GLITCH Docker - Infrastructure as Code Smell Detection

![GLITCH Logo](https://github.com/sr-lab/GLITCH/raw/main/logo.png)

**GLITCH** is a technology-agnostic framework for automated detection of Infrastructure as Code (IaC) smells. This Docker image provides an easy way to run GLITCH without local installation complexities.

## 🚀 Quick Start

### Pull and Run
```bash
# Pull the image
docker pull jahidularafat/glitch:latest

# Show help
docker run --rm jahidularafat/glitch:latest --help

# Analyze IaC scripts in current directory
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest --tech ansible --csv /workspace
```

### Using Docker Compose
```bash
# Create project structure
mkdir -p iac-scripts results

# Copy your IaC files to iac-scripts/
cp your-playbooks/* iac-scripts/

# Run analysis
docker-compose run --rm glitch --tech ansible --csv /workspace

# Interactive mode
docker-compose run --rm glitch-interactive
```

## 📋 Supported Technologies

| Technology | Status | Command |
|------------|--------|---------|
| **Ansible** | ✅ Full Support | `--tech ansible` |
| **Puppet** | ✅ Full Support | `--tech puppet` |
| **Terraform** | ✅ Full Support | `--tech terraform` |
| **Chef** | ⚠️ Limited Support | `--tech chef` |

*Note: Chef analysis may have limitations due to Ruby Ripper dependencies*

## 🔍 Analysis Examples

### Ansible Playbooks
```bash
docker run --rm -v $(pwd)/ansible-playbooks:/workspace \
  jahidularafat/glitch:latest \
  --tech ansible --csv --config /app/configs/ansible.yml /workspace
```

### Puppet Manifests
```bash
docker run --rm -v $(pwd)/puppet-manifests:/workspace \
  jahidularafat/glitch:latest \
  --tech puppet --csv --config /app/configs/puppet.yml /workspace
```

### Terraform Files
```bash
docker run --rm -v $(pwd)/terraform-files:/workspace \
  jahidularafat/glitch:latest \
  --tech terraform --csv --config /app/configs/terraform.yml /workspace
```

### With Module Structure Analysis
```bash
docker run --rm -v $(pwd)/iac-project:/workspace \
  jahidularafat/glitch:latest \
  --tech terraform --csv --module --config /app/configs/terraform.yml /workspace
```

## 💾 Save Results

### Save to Host Directory
```bash
mkdir -p results
docker run --rm \
  -v $(pwd)/iac-scripts:/workspace \
  -v $(pwd)/results:/results \
  jahidularafat/glitch:latest \
  --tech ansible --csv /workspace > results/analysis-$(date +%Y%m%d).csv
```

### Pipe Results
```bash
# Direct CSV output
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest \
  --tech puppet --csv /workspace > puppet-analysis.csv

# Pretty table output
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest \
  --tech ansible /workspace
```

## 🔧 Configuration

### Custom Configuration Files
```bash
# Use custom config
docker run --rm \
  -v $(pwd)/my-config.yml:/config/custom.yml \
  -v $(pwd)/iac-scripts:/workspace \
  jahidularafat/glitch:latest \
  --tech ansible --csv --config /config/custom.yml /workspace
```

### Built-in Configurations
The image includes default configurations:
- `/app/configs/ansible.yml`
- `/app/configs/puppet.yml`
- `/app/configs/terraform.yml`
- `/app/configs/chef.yml`

## 🛠️ Building from Source

### Prerequisites
- Docker installed
- Docker Hub account (for pushing)

### Build Commands
```bash
# Clone the repository
git clone https://github.com/sr-lab/GLITCH.git
cd GLITCH

# Build the image
docker build -t jahidularafat/glitch:latest .

# Test the build
docker run --rm jahidularafat/glitch:latest --help

# Push to Docker Hub
docker push jahidularafat/glitch:latest
```

### Automated Build Script
```bash
chmod +x build-and-push.sh
./build-and-push.sh
```

## 🐞 Troubleshooting

### Common Issues

**Permission Denied**
```bash
# Fix permissions
chmod -R 755 iac-scripts/
chmod -R 755 results/
```

**No Files Found**
```bash
# Check mounted directory
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest ls -la /workspace
```

**Configuration Issues**
```bash
# Use verbose output
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest \
  --tech ansible --csv /workspace --verbose
```

### Interactive Debugging
```bash
# Run shell in container
docker run --rm -it -v $(pwd):/workspace jahidularafat/glitch:latest /bin/bash

# Check GLITCH installation
docker run --rm jahidularafat/glitch:latest python -c "import glitch; print('OK')"
```

## 📊 Detection Capabilities

### Security Smells (9 types)
- Hard-coded secrets
- Invalid IP address binding
- HTTP without TLS
- Weak cryptography algorithms
- Missing security updates
- Admin by default
- Empty passwords
- Use of weak encryption protocols
- Suspicious comments

### Design & Implementation Smells (9 types)
- Long resource
- Complex expression
- Improper alignment
- Long statement
- Missing dependency
- Multifaceted abstraction
- Unnecessary abstraction
- Duplicate entity
- Misplaced attribute

## 📈 Output Formats

### CSV Output
```bash
# Generate CSV report
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest \
  --tech ansible --csv /workspace > analysis.csv
```

### Console Table
```bash
# Pretty formatted table
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest \
  --tech puppet /workspace
```

## 🔗 Links

- **Original Repository**: https://github.com/sr-lab/GLITCH
- **Docker Hub**: https://hub.docker.com/r/jahidularafat/glitch
- **Documentation**: https://github.com/sr-lab/GLITCH/tree/main/docs
- **Issues**: https://github.com/sr-lab/GLITCH/issues

## 📄 License

This project is licensed under the GPL-3.0 License - see the [LICENSE](https://github.com/sr-lab/GLITCH/blob/main/LICENSE) file for details.

## 📚 Citation

If you use GLITCH in your research, please cite:

```bibtex
@inproceedings{saavedraferreira22glitch,
  title={{GLITCH}: Automated Polyglot Security Smell Detection in Infrastructure as Code},
  author={Saavedra, Nuno and Ferreira, Jo{\~a}o F},
  booktitle={Proceedings of the 37th IEEE/ACM International Conference on Automated Software Engineering},
  year={2022}
}
```

## 🤝 Contributing

Issues and pull requests are welcome at the [original repository](https://github.com/sr-lab/GLITCH).

---
**Maintained by**: jahidularafat  
**Version**: 1.0.1  
**Last Updated**: September 2025