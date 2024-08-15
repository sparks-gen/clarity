# MKP041

## Table of Contents
- [MKP041](#mkp041)
  - [Table of Contents](#table-of-contents)
  - [Time Sheet](#time-sheet)
  - [Prioritising STRs](#prioritising-strs)
    - [Goal](#goal)
    - [Expected Results](#expected-results)
    - [Data](#data)
    - [Software](#software)
    - [Procedure](#procedure)
  - [Identifying SNPs](#identifying-snps)
    - [Goal](#goal-1)
    - [Expected results](#expected-results-1)
    - [Data](#data-1)
    - [Software](#software-1)
    - [Procedure](#procedure-1)

## Time Sheet
| Date       | Time start | Time end | Description |
|:----------:|-----------:|---------:|-------------|
| 2024-06-09 | 11:00      | 16:20    | ASP         |
| 2024-07-20 | 09:00      | 14:30    | STR lookup  |
| 2024-07-24 | 10:00      | 12:00    | STR lookup  |
| 2024-07-29 | 11:00      | 12:00    | STR lookup  |
| 2024-07-30 | 08:30      | 10:00    | STR lookup  |
| 2024-08-14 | 09:00      | | STR lookup  |

## Prioritising STRs

### Goal
Before SNPs are mined, we need to prioritise the list of 70 STRs to select those that are discriminatory for the African population.

### Expected Results
I will have a list of STRs that are workable for the African population.

### Data

### Software

### Procedure
1. Establish criteria for the STRs
   1. They need to be penta- or tetranucleotides
   2. Heterozygosity needs to be high (?)
2. Find data for the STR population information.

## Identifying SNPs

### Goal
Find all of the SNPs that are within 200bp of a list of STRs

### Expected results
I will have all of the STR's chromosomal positions.

### Data
* Provided STRs [Excel](https://www.dropbox.com/scl/fo/cidj71gqvwkqnirdysbtr/AB29AHrIFErmd34jwx4an3I/MKP041_resources/Kim%20and%20Rosenberg%20%282023%29.pdf?rlkey=8t87mvgrxp9m7mgdp7ra03js4&dl=0)
* Data from [Kim and Rosenberg](https://github.com/jk2236/RM_WGS)

### Software
* R version 4.3.2

### Procedure
1. Import all data in [R](strSnp.R) as dataframes

