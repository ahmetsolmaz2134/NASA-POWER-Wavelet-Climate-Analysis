# NASA POWER-Based Wavelet Analysis of Climate Variability in Southeastern Türkiye

## Overview

This project investigates the temporal variability and time–frequency characteristics of climate variables across Southeastern Türkiye using long-term NASA POWER meteorological data.

Unlike conventional trend-based climate analyses, this study applies wavelet-based methods to identify dominant periodicities, temporal changes in climate variability, and time-dependent relationships between meteorological variables.

The primary objective is to determine not only whether climate variables have changed over time, but also **when and at which temporal scales these changes have been most pronounced**.

---

## Research Objectives

The study aims to:

1. Analyze long-term variability in temperature, precipitation, and atmospheric moisture.
2. Identify dominant periodicities within climate time series.
3. Detect temporal changes in climate variability using continuous wavelet analysis.
4. Examine the relationship between temperature and precipitation in the time–frequency domain.
5. Investigate temperature–humidity and precipitation–humidity interactions.
6. Identify periods of statistically significant climate variability.
7. Evaluate whether climate relationships change across different temporal scales.

---

## Study Region

The study focuses on Southeastern Türkiye, a region characterized by:

- Strong climatic gradients
- Semi-arid and dry sub-humid conditions
- High summer temperatures
- Pronounced seasonal precipitation variability
- Increasing exposure to drought and heat extremes

The region is particularly suitable for time–frequency climate analysis because of its strong seasonal cycle and substantial interannual variability.

---

## Data Source

All meteorological data are obtained from the:

**NASA Prediction of Worldwide Energy Resources (NASA POWER)**

NASA POWER provides globally distributed meteorological and solar radiation datasets derived from satellite observations and numerical weather models.

### Temporal Coverage

**1981–2025**

### Temporal Resolution

Daily observations aggregated to monthly time series for wavelet analysis.

---

## Climate Variables

The primary variables used in this study are:

| Variable | Description |
|---|---|
| T2M | Mean air temperature at 2 m |
| T2M_MAX | Maximum air temperature at 2 m |
| T2M_MIN | Minimum air temperature at 2 m |
| PRECTOTCORR | Corrected precipitation |
| RH2M | Relative humidity at 2 m |

Additional variables may be incorporated during later stages of the analysis.

---

# Methodology

The analytical framework consists of several sequential stages.

## 1. Data Acquisition

Daily climate data will be obtained directly from the NASA POWER API.

The workflow is designed to be fully reproducible, allowing the complete dataset to be regenerated without manually downloading individual files.

---

## 2. Data Processing

The raw NASA POWER data will be:

- Imported into R
- Quality checked
- Converted to appropriate date formats
- Examined for missing observations
- Aggregated from daily to monthly observations
- Standardized where necessary for wavelet analysis

---

## 3. Descriptive Climate Analysis

Initial analyses will include:

- Monthly climatology
- Annual variability
- Long-term anomalies
- Seasonal variability
- Interannual variability

These analyses provide the climatic background necessary for interpreting the wavelet results.

---

## 4. Trend Analysis

Conventional statistical methods will be used as a complementary component of the study.

### Methods

- Mann–Kendall trend test
- Sen's slope estimator
- Anomaly analysis

The purpose of this stage is to determine whether statistically significant monotonic trends exist before examining their time–frequency structure.

---

# 5. Continuous Wavelet Transform (CWT)

The Continuous Wavelet Transform will constitute the core analytical method.

CWT decomposes a time series into both:

- Time
- Frequency / Period

This allows the detection of dominant oscillations and temporal changes in their strength.

### Main outputs

- Wavelet power spectrum
- Dominant periodicities
- Time-dependent variability
- Cone of Influence (COI)
- Statistical significance regions

The analysis will focus particularly on annual and multi-annual climate variability.

---

# 6. Cross-Wavelet Transform (XWT)

Cross-Wavelet Transform will be applied to investigate common high-power oscillations between climate variables.

Primary relationships include:

### Temperature ↔ Precipitation

### Temperature ↔ Relative Humidity

### Precipitation ↔ Relative Humidity

XWT will identify periods in which two climate variables exhibit strong common variability.

---

# 7. Wavelet Coherence (WTC)

Wavelet Coherence will be used to investigate localized relationships between climate variables in the time–frequency domain.

Unlike conventional correlation analysis, WTC allows relationships to vary across:

- Time
- Period
- Frequency

This provides a more detailed understanding of climate interactions.

Particular attention will be given to:

- Coherent periods
- Phase relationships
- Temporal changes in coupling
- Annual and multi-annual scales

---

# Research Questions

The study addresses the following questions:

### RQ1
What are the dominant temporal periodicities in temperature, precipitation, and atmospheric moisture across Southeastern Türkiye?

### RQ2
Have the dominant periodicities remained stable throughout the study period?

### RQ3
During which periods are climate variables characterized by statistically significant oscillations?

### RQ4
At which temporal scales do temperature and precipitation exhibit significant coherence?

### RQ5
Does the relationship between temperature and atmospheric moisture vary through time?

### RQ6
Are climate relationships stronger at seasonal, annual, or multi-annual time scales?

---

# Expected Outputs

The project will produce:

### Climate Time-Series Figures

- Temperature anomalies
- Precipitation anomalies
- Humidity variability
- Seasonal climate variability

### Wavelet Figures

- Temperature Wavelet Power Spectrum
- Precipitation Wavelet Power Spectrum
- Humidity Wavelet Power Spectrum
- Maximum temperature Wavelet Power Spectrum

### Cross-Wavelet Figures

- Temperature–Precipitation XWT
- Temperature–Humidity XWT
- Precipitation–Humidity XWT

### Wavelet Coherence Figures

- Temperature–Precipitation WTC
- Temperature–Humidity WTC
- Precipitation–Humidity WTC

### Statistical Results

- Mann–Kendall statistics
- Sen's slope
- Significant wavelet periods
- Dominant periodicities
- Wavelet coherence characteristics

---

# Reproducible Workflow

```text
NASA POWER API
       │
       ▼
Daily Climate Data
       │
       ▼
Quality Control & Processing
       │
       ▼
Monthly Climate Series
       │
       ├──────────────► Descriptive Analysis
       │
       ├──────────────► Mann–Kendall
       │
       ├──────────────► Sen's Slope
       │
       ▼
Continuous Wavelet Transform
       │
       ├──────────────► Wavelet Power Spectrum
       │
       ├──────────────► Cross-Wavelet Transform
       │
       └──────────────► Wavelet Coherence
       │
       ▼
Time–Frequency Climate Interpretation
