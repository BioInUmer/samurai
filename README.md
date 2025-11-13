# SAMurai <img width="350" height="350" alt="image" src="https://github.com/user-attachments/assets/6f11556c-b14a-4386-ab99-9695e1c2592a" />

This SAM file analyst takes multiple alignments and an assembly map to instantly summarize total reads and their distribution across the genome.

---

## 🎴 Features

- Handles multiple SAM files at once  
- Automatically validates input types  
- Summarizes total and aligned reads  
- Joins results with chromosome mapping from an assembly report
- Reports read counts per accession-chromosome pair  
- Produces a clean, ready-to-read output file (`output.txt`)

---

## ☑︎ Requirements

- Linux or macOS (Bash)
- Common Unix tools: `awk`, `grep`, `sort`, `uniq`, `join`

---

## ⏯︎ Usage

Run the script from your terminal of choice:

```bash
bash sam_urai.sh file1.sam file2.sam ... assembly_report.txt
```

---

## 📁 Repo Structure
```
sam-align-summary/
│
├── sam_urai.sh     # Main script
├── example_data/                # Example input files
│   ├── sample1.sam
│   ├── sample2.sam
│   └── assembly_report.txt
├── output_example.txt           # Example output
├── LICENSE
└── README.md
```

---

## ©️ License






