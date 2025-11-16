<img width="200" height="200" alt="image" src="https://github.com/user-attachments/assets/5c9dd162-d42f-4f39-940d-7e740d5a5661" />

# samurai 

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/bash-%3E%3D4.0-green.svg)](https://www.gnu.org/software/bash/)

This SAM file analyst takes multiple alignments and an assembly map to instantly summarize total reads and their distribution across the genome.

---

## 🎴 Features

- Handles multiple SAM files at once  
- Automatically validates input types  
- Summarizes total and aligned reads  
- Joins results with chromosome mapping from an assembly report
- Reports read counts per accession-chromosome pair  
- Produces a clean, ready-to-read output file (`output.txt`)

## Documentation
> 📄 **For detailed documentation, workflow explanations, and technical specifications, see the PDF file (Report.pdf) included in this repository. Note: RUScript.sh = samurai.sh**

---

## Installation

## ☑︎ Requirements

- Linux/macOS/Unix environment
- Bash ≥ 4.0
- Standard Unix tools: `awk`, `grep`, `sort`, `uniq`, `join`

### Clone the Repository

```bash
git clone https://github.com/BioInUmer/samurai.git
cd samurai
chmod +x samurai.sh
```
---

## ▶︎ Usage

### Basic Syntax

```bash
./samurai.sh <file1.sam> [file2.sam ...] <assembly_report>
```

### Rules
- Provide at least ONE SAM file
- Assembly report must be the LAST parameter
- All files except the last must have `.sam` extension

### Examples

```bash
# Single file
./samurai.sh sample.sam assembly_report.txt

# Multiple files
./samurai.sh sample1.sam sample2.sam sample3.sam assembly_report.txt
```

### Input Files

- **SAM files**: Standard alignment format with header lines (`@`) and alignment records
- **Assembly report**: Tab-delimited file mapping accession numbers (column 5) to chromosome names (column 1)

See the included PDF for detailed format specifications.

### Output

Generates `output.txt` with:
- Total reads processed
- Total aligned reads  
- Per-chromosome alignment counts
- Execution time

### Sample output

```
=== SAM FILES ALIGNMENT ANALYSIS ===

Total reads processed: 1500000
Aligned reads:          1350000

Accession             Chromosome      Aligned Reads
--------------------- --------------- ---------------
NC_000001.11          1               450000
NC_000002.12          2               320000
NC_000023.11          X               150000

Total execution time: 1 s
```

View results: `cat output.txt`

---

## ⚠️ Error Handling

**Permission denied:**
```bash
chmod +x samurai.sh
```

**Files not found:** Use absolute paths or verify current directory

**Empty output:** Check SAM file format and assembly report compatibility

For detailed troubleshooting, see the included PDF documentation.

---

## 📁 Repo Structure
```
samurai/
│
├── samurai.sh                   # Main script
├── example_data/                # Example input files
│   ├── sample1.sam
│   └── assembly_report.txt
├── Report.pdf                   # Report PDF file
├── output_example.txt           # Example output
├── LICENSE
└── README.md
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

##
**Version:** 1.0.0 | **Last Updated:** November 2025







