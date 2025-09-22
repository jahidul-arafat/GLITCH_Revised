# GLITCH-Revised
##### Fixed by Jahidul Arafat; ex-Oracle (Senior Solution and Cloud Architect, Oracle Singapore); Presidential and Woltosz (Dual fellowship) graduate research Fellow, AU, CSSE; 

[![DOI](https://zenodo.org/badge/453066827.svg)](https://zenodo.org/badge/latestdoi/453066827)
[![License: GPL-3.0](https://badgen.net/github/license/sr-lab/GLITCH)](https://www.gnu.org/licenses/gpl-3.0)
[![Python Version](https://img.shields.io/badge/python-3.10+-blue)](https://www.python.org/downloads/)
[![Last release](https://badgen.net/github/release/sr-lab/GLITCH/)](https://github.com/sr-lab/GLITCH/releases)
[![Docker Image](https://img.shields.io/badge/docker-jahidularafat/glitch-blue)](https://hub.docker.com/r/jahidularafat/glitch)

![alt text](https://github.com/sr-lab/GLITCH/blob/main/logo.png?raw=true)

GLITCH is a technology-agnostic framework that enables automated detection of IaC smells. GLITCH allows polyglot smell detection by transforming IaC scripts into an intermediate representation, on which different smell detectors can be defined. GLITCH currently supports the detection of nine different security smells [1, 2] and nine design & implementation smells [3] in scripts written in Puppet, Ansible, Chef, or Terraform.

## Recent Fixes and Updates

### Python 3.12 Compatibility Fixed
- **Issue**: Fixed pandas/numpy binary incompatibility that caused `ValueError: numpy.dtype size changed` on Python 3.12
- **Solution**: Updated pandas from 1.5.3 to ^2.1.0 and added numpy ^1.26.0 constraint in pyproject.toml
- **Status**: GLITCH now fully supports Python 3.10, 3.11, and 3.12

### Docker Containerization Added
- **New Feature**: Complete Docker support with pre-built images available on Docker Hub
- **Benefits**: No local installation complexities, consistent environment across platforms
- **Availability**: `docker pull jahidularafat/glitch:latest`

### Technology Support Matrix
| Technology | Local Install | Docker Support | Status |
|------------|---------------|----------------|---------|
| **Ansible** | ✅ Full | ✅ Full | Fully tested |
| **Puppet** | ✅ Full | ✅ Full | Fully tested |
| **Terraform** | ✅ Full | ✅ Full | Fully tested |
| **Chef** | ⚠️ Requires Ruby | ⚠️ Limited | Ruby dependency issues |

## Installation Options

### Option 1: Docker (Recommended)

**Quick Start:**
```bash
# Pull and run
docker pull jahidularafat/glitch:latest

# Show help
docker run --rm jahidularafat/glitch:latest --help

# Analyze IaC scripts
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest --tech ansible --csv /workspace
```

**Docker Compose Setup:**
```bash
# Create project structure
mkdir -p iac-scripts results
cd iac-scripts && cp /path/to/your/iac/files/* . && cd ..

# Create docker-compose.yml (see Docker section below)
# Run analysis
docker-compose run --rm glitch-ansible
```

### Option 2: Local Installation

**Prerequisites:**
- Python 3.10+ (3.12 supported)
- For Chef analysis: Ruby with Ripper library

**Install:**
```bash
python -m pip install -e .
```

**For Chef support:**
```bash
# Install Ruby and Ripper
sudo apt-get install ruby ruby-dev  # Ubuntu/Debian
brew install ruby                   # macOS
gem install ripper
```

### Option 3: Poetry Installation

```bash
poetry install
```

**Warning**: VSCode extension doesn't work with Poetry installation due to PATH requirements.

## Usage

### Docker Usage (Recommended)

**Basic Commands:**
```bash
# Analyze Ansible playbooks
docker run --rm -v $(pwd)/playbooks:/workspace \
  jahidularafat/glitch:latest --tech ansible --csv /workspace

# Analyze Puppet manifests
docker run --rm -v $(pwd)/manifests:/workspace \
  jahidularafat/glitch:latest --tech puppet --csv /workspace

# Analyze Terraform files
docker run --rm -v $(pwd)/terraform:/workspace \
  jahidularafat/glitch:latest --tech terraform --csv /workspace

# Interactive mode for debugging
docker run --rm -it -v $(pwd):/workspace jahidularafat/glitch:latest /bin/bash
```

**Save Results:**
```bash
# Save analysis to host file
docker run --rm -v $(pwd):/workspace \
  jahidularafat/glitch:latest --tech ansible --csv /workspace > analysis.csv

# With timestamp
docker run --rm -v $(pwd):/workspace \
  jahidularafat/glitch:latest --tech puppet --csv /workspace > "analysis-$(date +%Y%m%d).csv"
```

**Docker Compose Configuration:**
```yaml
version: '3.8'
services:
  glitch-ansible:
    image: jahidularafat/glitch:latest
    volumes:
      - ./iac-scripts:/workspace
      - ./results:/results
    command: ["--tech", "ansible", "--csv", "/workspace"]
  
  glitch-puppet:
    image: jahidularafat/glitch:latest
    volumes:
      - ./iac-scripts:/workspace
      - ./results:/results
    command: ["--tech", "puppet", "--csv", "/workspace"]
```

### Local Usage

**Basic Commands:**
```bash
# Show all options
glitch --help

# Analyze files with CSV output
glitch --tech (chef|puppet|ansible|terraform) --csv --config PATH_TO_CONFIG PATH_TO_FILE_OR_FOLDER

# Include module structure analysis
glitch --tech ansible --module --csv /path/to/playbooks

# Use specific configuration
glitch --tech puppet --config configs/puppet.yml --csv /path/to/manifests
```

**Poetry Usage:**
```bash
poetry run glitch --help
# or
poetry shell
glitch --help
```

## Configuration

### Built-in Configurations
- `configs/ansible.yml` - Ansible-specific rules
- `configs/puppet.yml` - Puppet-specific rules
- `configs/chef.yml` - Chef-specific rules
- `configs/terraform.yml` - Terraform-specific rules

### Custom Configurations
Create custom configs with the same structure as existing ones in the `configs` folder.

**Docker with custom config:**
```bash
docker run --rm \
  -v $(pwd)/my-config.yml:/config/custom.yml \
  -v $(pwd)/iac-scripts:/workspace \
  jahidularafat/glitch:latest \
  --tech ansible --config /config/custom.yml --csv /workspace
```

## Examples

### Analyze Multiple Technologies
```bash
# Local
glitch --tech ansible --csv ./playbooks > ansible-results.csv
glitch --tech puppet --csv ./manifests > puppet-results.csv
glitch --tech terraform --csv ./tf-files > terraform-results.csv

# Docker
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest --tech ansible --csv /workspace/playbooks > ansible.csv
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest --tech puppet --csv /workspace/manifests > puppet.csv
docker run --rm -v $(pwd):/workspace jahidularafat/glitch:latest --tech terraform --csv /workspace/terraform > terraform.csv
```

### Batch Processing Script
```bash
#!/bin/bash
technologies=("ansible" "puppet" "terraform")
for tech in "${technologies[@]}"; do
  docker run --rm -v $(pwd):/workspace \
    jahidularafat/glitch:latest --tech $tech --csv /workspace > "${tech}-$(date +%Y%m%d).csv"
done
```

## Troubleshooting

### Common Issues

**Docker Permission Issues:**
```bash
# Fix file permissions
chmod -R 755 iac-scripts/
sudo chown -R $USER:$USER results/
```

**Python 3.12 ImportError (Legacy Issue):**
If you encounter numpy/pandas import errors, update your pyproject.toml:
```toml
pandas = "^2.1.0"
numpy = "^1.26.0"
```

**Ruby/Chef Issues:**
For local Chef analysis, ensure Ruby and Ripper are installed:
```bash
ruby -e "require 'ripper'; puts 'OK'"
```

**Docker Build Issues:**
```bash
# Clean Docker cache and rebuild
docker system prune -f
docker build --no-cache -t glitch-local .
```

## Paper and Academic Usage

"[GLITCH: Automated Polyglot Security Smell Detection in Infrastructure as Code](https://arxiv.org/abs/2205.14371)" is the main paper that describes the implementation of security smells in GLITCH. It also presents a large-scale empirical study  that analyzes security smells on three large datasets containing 196,755 IaC scripts and 12,281,251 LOC.

**If you use GLITCH or any of its datasets, please cite:**

- Nuno Saavedra and João F. Ferreira. 2022. [GLITCH: Automated Polyglot Security Smell Detection in Infrastructure as Code](https://arxiv.org/abs/2205.14371). In 37th IEEE/ACM International Conference on Automated Software Engineering (ASE '22), October 10–14, 2022, Rochester, MI, USA. ACM, New York NY, USA, 12 pages. https://doi.org/10.1145/3551349.3556945

 ```bibtex
 @inproceedings{saavedraferreira22glitch,
  title={{GLITCH}: Automated Polyglot Security Smell Detection in Infrastructure as Code},
  author={Saavedra, Nuno and Ferreira, Jo{\~a}o F},
  booktitle={Proceedings of the 37th IEEE/ACM International Conference on Automated Software Engineering},
  year={2022}
}
 ```

- 	Nuno Saavedra, João Gonçalves, Miguel Henriques, João F. Ferreira, Alexandra Mendes. 2023. [Polyglot Code Smell Detection for Infrastructure as Code with GLITCH](https://arxiv.org/pdf/2308.09458.pdf). In 38th IEEE/ACM International Conference on Automated Software Engineering (ASE '23), September 11-15, 2023, Luxembourg.
     https://doi.org/10.1109/ASE56229.2023.00162

```bibtex
@inproceedings{saavedra23glitchdemo,
  author={Saavedra, Nuno and Gonçalves, João and Henriques, Miguel and Ferreira, João F. and Mendes, Alexandra},
  booktitle={2023 38th IEEE/ACM International Conference on Automated Software Engineering (ASE)}, 
  title={Polyglot Code Smell Detection for Infrastructure as Code with GLITCH}, 
  year={2023},
  pages={2042-2045},
  doi={10.1109/ASE56229.2023.00162}
}
```

## Tests

To run the tests for GLITCH go to the folder ```glitch``` and run:
```bash
python -m unittest discover tests
```

**Docker testing:**
```bash
docker run --rm jahidularafat/glitch:latest python -m unittest discover glitch/tests
```

## Documentation

More information can be found in [GLITCH's documentation](https://github.com/sr-lab/GLITCH/wiki).

## VSCode extension

GLITCH has a Visual Studio Code extension which is available [here](https://github.com/sr-lab/GLITCH/tree/main/vscode-extension/glitch).

**Note**: The extension requires GLITCH to be installed locally (not via Poetry or Docker).

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

For Docker-related contributions, test with:
```bash
docker build -t glitch-test .
docker run --rm glitch-test --help
```

## License

[GPL-3.0](https://choosealicense.com/licenses/gpl-3.0/)

## References

<sub>[1] Rahman, A., Parnin, C., & Williams, L. (2019, May). The seven sins: Security smells in infrastructure as code scripts. In 2019 IEEE/ACM 41st International Conference on Software Engineering (ICSE) (pp. 164-175). IEEE.</sub>

<sub>[2] Rahman, A., Rahman, M. R., Parnin, C., & Williams, L. (2021). Security smells in ansible and chef scripts: A replication study. ACM Transactions on Software Engineering and Methodology (TOSEM), 30(1), 1-31.</sub>

<sub>[3] Schwarz, J., Steffens, A., & Lichter, H. (2018, September). Code smells in infrastructure as code. In 2018 11th International Conference on the Quality of Information and Communications Technology (QUATIC) (pp. 220-228). IEEE.</sub>