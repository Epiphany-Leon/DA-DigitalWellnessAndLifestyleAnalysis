# Digital Wellness & Lifestyle Analysis: A Machine Learning Approach

## 📖 Executive Summary

In an era where "screen time" is often broadly demonized, this project utilizes advanced data analytics to decouple the effects of different digital behaviors on mental well-being. Using R, we applied both supervised and unsupervised learning techniques to investigate the relationship between digital habits (social media, gaming, etc.), lifestyle factors (sleep, activity), and mental health outcomes.

**Key Insight:** Not all screen time is created equal. Our models identified Social Media usage as the primary stressor, pinpointing a critical threshold of 3.85 hours/day, whereas gaming and other digital activities showed weaker correlations with high stress.

**Data Source:** The analysis is based on the Tech Use and Stress & Wellness dataset from Kaggle, comprising 5,000 survey responses on digital habits and psychological indicators.

## 🎯 Research Questions

1. **Association**: How are specific digital behaviors and lifestyle habits associated with mental health scores and stress levels?
2. **Prediction**: Can we predict an individual's stress level based on their digital footprint?
3. **Segmentation**: Are there distinct user personas that naturally emerge from digital usage patterns?

## 🛠️ Methodology

We employed a multi-stage analytic approach using **R**:
1. Exploratory Data Analysis (EDA) & Statistics
   - Conducted correlation analysis (Heatmaps) to identify relationships between variables.
   - Performed **Linear Regression** to quantify the impact of sleep quality vs. sleep duration on mental health scores.
2. Supervised Learning (Stress Prediction)
   - **Models**: Implemented Decision Trees and Random Forest algorithms.
   - **Goal**: To classify users into "High Stress" vs. "Low/Moderate Stress" groups.
   - **Result**: The Decision Tree model successfully identified specific time thresholds for risk factors.
3. Unsupervised Learning (User Segmentation)
   - Technique: K-Means Clustering.
   - Optimization: Used the Elbow Method to determine the optimal number of clusters ($k=3$).
   - Result: Discovered three distinct digital lifestyle personas.

## 📊 Key Findings & Results

1. The "3.85 Hour" Tipping Point

Using Decision Tree analysis, we identified that Social Media usage is the strongest predictor of high stress.
- Users spending > 3.85 hours/day on social media are significantly more likely to report high stress levels.
- Total screen time was a less effective predictor than the type of screen time.

2. Sleep Quality > Sleep Duration

Regression analysis revealed that **Sleep Quality** ($R^2$ impact) is a statistically stronger predictor of mental health scores than mere **Sleep Duration**. A holistic lifestyle approach focusing on rest quality is more effective than simple hour-counting.

3. User Personas (Clustering)

We identified three distinct user clusters based on digital behavior:

Persona,Characteristics,Wellness Profile
Cluster 1: Balanced Users,"Low screen time, balanced activity.","Lowest Stress, Highest Mental Health Score."
Cluster 2: Gamers,"High gaming hours, moderate social media.","Moderate Stress, varied mental health."
Cluster 3: Heavy Social Users,"Extremely high social media use, low physical activity.","Highest Stress, Lowest Mental Health Score."

## 💡 Practical Implications

- For Digital Wellbeing Apps: Interventions should move away from generic "screen time limits" and focus on specific social media caps (targeting the < 3.85h threshold).
- For Public Health: "Digital Hygiene" campaigns should distinguish between passive scrolling (high risk) and interactive gaming/entertainment (moderate risk), while prioritizing sleep quality improvement.

## 💻 Tech Stack
- Language: R
- Libraries:
  - `tidyverse` (Data manipulation)
  - `caret`, `rpart` (Machine Learning models)
  - `cluster`, `factoextra` (K-Means Clustering)
  - `corrplot`, `ggplot2` (Visualization)


**P.S.** *This project was completed as part of the Data Analytics curriculum at Johns Hopkins Carey Business School (Team Viper).*
