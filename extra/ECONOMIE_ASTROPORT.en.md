# 💰 Astroport.ONE Economic Guide

This guide explains how to use the economic calculators to plan your Astroport deployment and understand the cooperative economic model.

## 🎯 Overview

Astroport.ONE operates according to a **cooperative economic model** where:
- Users pay rents (MULTIPASS) or purchase shares (ZEN Cards)
- Captains manage nodes and collect revenues
- Surplus is distributed according to the **3×1/3 rule** (Treasury, R&D, Assets)
- Profits finance the acquisition of common goods (forests, lands)

## 📊 Available Calculators

### 1. Satellite Simulator (Web)

**URL**: [https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html)

**Usage**: Economic calculation for a **single satellite node** (Raspberry Pi 5)

**Features**:
- Interactive sliders to adjust parameters
- Automatic revenue and cost calculation
- Cooperative surplus visualization
- Real-time 3×1/3 distribution

**Adjustable Parameters**:
- Number of MULTIPASS users (1 Ẑ/week)
- Number of ZEN Cards users (50 Ẑ/year)
- PAF (Participation in Fees) weekly
- Service rates

### 2. Constellation Simulator (Web)

**URL**: [https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html)

**Usage**: Economic modeling of a **complete constellation** (network of nodes)

**Features**:
- Constellation modeling (1 Hub + 24 Satellites)
- Team cost calculation (developers, community managers)
- Ecological impact projection (forest acquisition)
- Pre-configured scenarios
- Network profitability analysis

**Adjustable Parameters**:
- Number of captains/nodes
- Total number of users
- R&D team (developers, community managers)
- Team salaries

**Pre-configured Scenarios**:
1. **Local Satellite**: 100 users, 1 developer, 10 nodes
2. **Regional Constellation**: 500 users, 2 developers, 25 nodes
3. **Mega-Constellation**: 1500 users, 5 developers, 100 nodes

### 3. ODS Spreadsheets (Offline)

**Files**:
- `Satellite Economy.ods` - Model for a satellite
- `SWARM Economy.ods` - Model for a swarm

**Usage**: Advanced planning and offline analysis

**Advantages**:
- Customizable formulas
- Multiple scenario analysis
- Data export
- Complex calculations

## 📖 Usage Guide

### Step 1: Define Your Objective

**Questions to ask yourself**:
- Do you want to manage a single satellite or a constellation?
- How many users are you targeting?
- Do you have an R&D team to finance?
- What is your infrastructure budget?

### Step 2: Use the Web Simulator

#### For a Single Satellite

1. Open the [Satellite Simulator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html)
2. Adjust the sliders:
   - Number of MULTIPASS users
   - Number of ZEN Cards users
   - Weekly PAF
3. Observe the results:
   - Total revenues
   - Infrastructure costs
   - Cooperative surplus
   - 3×1/3 distribution

#### For a Constellation

1. Open the [Constellation Simulator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html)
2. Choose a pre-configured scenario or create your own
3. Adjust parameters:
   - Number of captains/nodes
   - Number of users
   - R&D team
4. Analyze KPIs:
   - Break-even point
   - Gross margin
   - Jobs created
   - Ecological impact (m² of forest)

### Step 3: Analyze Results

**Key indicators to monitor**:

1. **Break-even point**: Minimum number of users to be profitable
2. **Gross margin**: Percentage of revenue after direct costs
3. **Cooperative surplus**: Amount available for 3×1/3 distribution
4. **Ecological impact**: Forest-garden area acquired per cycle

**Recommended objectives**:
- Break-even point < 50% of capacity
- Gross margin > 60%
- Cooperative surplus > 30% of revenue

### Step 4: Plan with ODS (Optional)

For deeper analysis:

1. Download ODS files
2. Open with LibreOffice Calc or Google Sheets
3. Customize formulas according to your needs
4. Create multiple scenarios
5. Export data for presentation

## 💡 Concrete Examples

### Example 1: Local Satellite (Beginner)

**Configuration**:
- 1 satellite (Raspberry Pi 5)
- 50 MULTIPASS users (1 Ẑ/week)
- 10 ZEN Cards users (50 Ẑ/year)
- PAF: 14 Ẑ/week

**Calculations**:
- MULTIPASS revenue: 50 × 1 Ẑ/week = 50 Ẑ/week = 2600 Ẑ/year
- ZEN Cards revenue: 10 × 50 Ẑ/year = 500 Ẑ/year
- Total revenue: 3100 Ẑ/year
- PAF costs: 14 Ẑ/week = 728 Ẑ/year
- Captain remuneration: 2× PAF = 28 Ẑ/week = 1456 Ẑ/year
- Surplus: 3100 - 728 - 1456 = 916 Ẑ/year
- 3×1/3 distribution: ~305 Ẑ for each fund (Treasury, R&D, Assets)

**Result**: Viable satellite with modest but positive surplus.

### Example 2: Regional Constellation

**Configuration**:
- 25 nodes (1 Hub + 24 Satellites)
- 400 MULTIPASS users
- 100 ZEN Cards users
- 2 developers (4340 Ẑ/month each)
- 1 community manager (1360 Ẑ/month)

**Calculations** (use the [Constellation Simulator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html)):
- Recurring revenue: ~208k Ẑ/year
- Share purchase: 50k Ẑ/year
- Break-even point: ~180 users
- Gross margin: ~85%
- Ecological impact: ~400 m² of forest/month

**Result**: Very viable constellation with complete R&D team.

## 🎯 Tips to Optimize Your Model

### 1. Optimal User Mix

**Recommendation**: 80% MULTIPASS + 20% ZEN Cards

**Why**:
- MULTIPASS: Stable recurring revenue
- ZEN Cards: Initial capital + recurring revenue
- Balance between stability and growth

### 2. Infrastructure Sizing

**Capacity per station**:
- **250 MULTIPASS** maximum per satellite
- **24 ZEN Cards** maximum per satellite

**Node calculation**:
```
Nodes needed = MAX(
  (MULTIPASS / 250),
  (ZEN Cards / 24)
)
```

### 3. R&D Team

**Recommendations**:
- **1 developer** for 10-15 nodes
- **1 community manager** for 200-300 users
- Salaries: Developer 3080-5600 Ẑ/month, CM 1100-1620 Ẑ/month

### 4. Optimal PAF

**Default value**: 14 Ẑ/week

**Adjustments**:
- Raspberry Pi 5: 10-14 Ẑ/week
- Gaming PC: 20-30 Ẑ/week
- According to actual costs (electricity, internet)

## 🌍 Country-Specific Legal Considerations

### United States

**Cooperative Structure**:
- Consider forming as a **Worker Cooperative** or **Consumer Cooperative**
- Each state has different cooperative laws (check your state)
- IRS tax-exempt status possible for certain cooperative structures

**Cryptocurrency Regulations**:
- **SEC regulations**: ẐEN may be considered a security - consult legal counsel
- **State regulations**: Vary by state (NY BitLicense, etc.)
- **Tax obligations**: Report as income, capital gains, or business income
- **KYC/AML**: Required for money transmission services

**Tax Framework**:
- **Federal**: Report cryptocurrency transactions on Form 8949
- **State**: Varies by state
- **Cooperative tax status**: May qualify for Subchapter T tax treatment

**Recommendations**:
- Consult with a cooperative attorney and cryptocurrency tax specialist
- Consider forming in a crypto-friendly state (Wyoming, Delaware)
- Implement proper KYC/AML procedures
- Maintain detailed accounting records

### United Kingdom

**Cooperative Structure**:
- **Community Benefit Society** or **Co-operative Society** registration
- FCA registration may be required
- One member, one vote governance

**Cryptocurrency Regulations**:
- **FCA registration**: Required for cryptoasset activities
- **AML regulations**: Strict KYC/AML requirements
- **Tax**: Capital Gains Tax on cryptocurrency profits

**Tax Framework**:
- **Capital Gains Tax**: 10-20% on crypto profits
- **Income Tax**: If trading as business
- **VAT**: Generally not applicable to cryptocurrency

**Recommendations**:
- Register with FCA if providing crypto services
- Implement robust KYC/AML procedures
- Consider Community Benefit Society structure
- Consult with UK cooperative and crypto legal experts

### Canada

**Cooperative Structure**:
- **Cooperative Corporation** under provincial or federal law
- Tax-exempt status possible for certain cooperatives
- Democratic governance (one member, one vote)

**Cryptocurrency Regulations**:
- **FINTRAC registration**: Required for money services businesses
- **Provincial regulations**: Vary by province
- **Tax**: Treated as commodity or capital property

**Tax Framework**:
- **Capital Gains**: 50% inclusion rate
- **Business Income**: If trading as business
- **GST/HST**: May apply to services

**Recommendations**:
- Register with FINTRAC if required
- Consider federal or provincial cooperative incorporation
- Implement KYC/AML procedures
- Consult with Canadian cooperative and crypto legal experts

### Australia

**Cooperative Structure**:
- **Co-operative** registration under state/territory law
- Tax concessions available for certain cooperatives
- Democratic governance structure

**Cryptocurrency Regulations**:
- **AUSTRAC registration**: Required for digital currency exchange services
- **ASIC regulations**: May apply depending on activities
- **Tax**: Capital Gains Tax applies

**Tax Framework**:
- **Capital Gains Tax**: 50% discount for assets held >12 months
- **Income Tax**: If trading as business
- **GST**: Generally not applicable to cryptocurrency

**Recommendations**:
- Register with AUSTRAC if providing exchange services
- Consider state cooperative registration
- Implement KYC/AML procedures
- Consult with Australian cooperative and crypto legal experts

## 📈 Interpreting Results

### Break-Even Point

**Definition**: Minimum number of users to cover all costs.

**Interpretation**:
- < 50% of capacity: Excellent
- 50-70% of capacity: Good
- > 70% of capacity: Needs improvement

### Gross Margin

**Definition**: Percentage of revenue after direct costs.

**Interpretation**:
- > 80%: Excellent
- 60-80%: Good
- < 60%: Needs optimization

### Cooperative Surplus

**Definition**: Amount available for 3×1/3 distribution.

**Distribution**:
- 1/3 Treasury (liquidity)
- 1/3 R&D (innovation)
- 1/3 Assets (forests, lands)

## 🔗 Additional Resources

- [ZEN.ECONOMY.readme.md](https://github.com/papiche/Astroport.ONE/blob/master/RUNTIME/ZEN.ECONOMY.readme.md) - Complete economic model documentation
- [UPlanet Cooperative](https://ipfs.copylaradio.com/ipns/copylaradio.com/entrance.html) - Cooperative website
- [Satellite Simulator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.html) - Web calculator for satellite
- [Constellation Simulator](https://ipfs.copylaradio.com/ipns/copylaradio.com/economy.Constellation.html) - Web calculator for constellation

## ❓ Frequently Asked Questions

### Can I modify the rates?

Yes, rates are adjustable in the simulators. However, default values (1 Ẑ/week for MULTIPASS, 50 Ẑ/year for ZEN Card) are recommended for network consistency.

### How to calculate my ROI?

Use the web simulators to project over 12 months. ROI depends on:
- Initial investment (hardware)
- Number of users
- Infrastructure costs
- Generated surplus

### What is the maximum capacity of a satellite?

- **250 MULTIPASS** (uDRIVE 10GB each)
- **24 ZEN Cards** (NextCloud 128GB each)

### How to join the R&D team?

Check job offers on the Monnaie Libre forum. Positions are financed by the R&D fund (1/3 of cooperative surplus).

---

**Last updated**: Based on UPlanet web simulators and ZEN.ECONOMY.readme.md documentation

