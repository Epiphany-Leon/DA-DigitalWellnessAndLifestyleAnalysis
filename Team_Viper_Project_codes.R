## Data Analytics Group Project
## Team Viper
## Dec 5, 2025


library(tidyverse)
library(corrplot)
library(broom)
library(RColorBrewer)

# Load Data
raw_data <- read_csv("Tech_Use_Stress_Wellness.csv")
summary.data.frame(raw_data)

# --- Preprocessing ---
clean_data <- raw_data %>%
  drop_na() %>%
  mutate(
    High_Stress = if_else(stress_level > median(stress_level), 1, 0),
    High_Stress = as.factor(High_Stress)
  )

# --- EDA: Correlation Heatmap ---
## Clear previous graphics device to prevent margin errors
if(!is.null(dev.list())) dev.off()
## Set global font family to Serif (Times New Roman)
par(family = "serif") 
## Prepare data for correlation
cor_matrix <- clean_data %>%
  dplyr::select(where(is.numeric)) %>%
  cor(use = "complete.obs")
## Generate the plot
aesthetic_col <- colorRampPalette(rev(brewer.pal(n = 10, name = "RdBu")))(200)
corrplot(cor_matrix, 
         method = "color",     
         type = "full",        
         tl.col = "black",     
         tl.srt = 45,
         tl.cex = 0.6,
         col = aesthetic_col,
         outline = TRUE,
         mar = c(0,0,1,0),
)

summary.data.frame(clean_data)

# --- Linear Regression ---
lm_model1 <- lm(mental_health_score ~ age + entertainment_hours + gaming_hours + 
                 sleep_duration_hours + sleep_quality + mood_rating + 
                 physical_activity_hours_per_week + mindfulness_minutes_per_day, 
               data = clean_data)
summary(lm_model1)

lm_model2 <- lm(stress_level ~ gaming_hours + daily_screen_time_hours + social_media_hours +
                  work_related_hours, 
                data = clean_data)
summary(lm_model2)



# --- Classification ---
library(class)
library(tree)

# Define Predictors (Strictly Digital Usage Patterns)
# We manually select only tech-related variables to answer the research question
predictors <- c("daily_screen_time_hours", 
                "phone_usage_hours", 
                "laptop_usage_hours", 
                "tablet_usage_hours", 
                "tv_usage_hours", 
                "social_media_hours", 
                "work_related_hours", 
                "entertainment_hours", 
                "gaming_hours")

## Split data into Train and Test (80/20)
set.seed(123)
train_index <- sample(1:nrow(clean_data), 0.8 * nrow(clean_data))
train_data  <- clean_data[train_index, ]
test_data   <- clean_data[-train_index, ]


# KNN
## Extract numeric matrices for KNN
train_X_raw <- train_data[, predictors]
test_X_raw  <- test_data[, predictors]

train_Y <- train_data$High_Stress
test_Y  <- test_data$High_Stress

## Scale test data
train_X_scaled <- scale(train_X_raw)
train_scale_attr <- attributes(train_X_scaled)

test_X_scaled <- scale(test_X_raw, 
                       center = train_scale_attr$`scaled:center`, 
                       scale = train_scale_attr$`scaled:scale`)

## KNN Model (k=5)
knn_pred <- knn(train = train_X_scaled, 
                test  = test_X_scaled, 
                cl    = train_Y, 
                k     = 5)

## Evaluate KNN
knn_conf_matrix <- table(Predicted = knn_pred, Actual = test_Y)
print(knn_conf_matrix)

knn_accuracy <- mean(knn_pred == test_Y)
cat("KNN Accuracy:", round(knn_accuracy * 100, 2), "%\n")


# Decision Tree
## Build the Tree Model
# We create a subset containing ONLY High_Stress and our digital predictors
# This forces the tree to ignore 'mood_rating' or 'sleep'
tree_data_subset <- train_data[, c("High_Stress", predictors)]

tree_model <- tree(High_Stress ~ ., data = tree_data_subset)
summary(tree_model)

## Visualize the Tree
plot(tree_model)
text(tree_model, pretty = 0)

## Evaluate Tree Performance
tree_pred_class <- predict(tree_model, test_data, type = "class")

dt_conf_matrix <- table(Predicted = tree_pred_class, Actual = test_Y)
print(dt_conf_matrix)

dt_accuracy <- mean(tree_pred_class == test_Y)
cat("Decision Tree Accuracy:", round(dt_accuracy * 100, 2), "%\n")

# Final Comparison
cat("\n>>> Winner:", ifelse(dt_accuracy > knn_accuracy, "Decision Tree", "KNN"), "\n")



# --- Clustering ---
# Identify User Personas
## Select usage features and scale them
usage_vars <- c("daily_screen_time_hours",
                "social_media_hours",
                "gaming_hours")

## Subset to usage variables and standardize (mean 0, sd 1)
cluster_data <- scale(raw_data[ , usage_vars])


## Elbow Method to decide k
wss <- numeric(10)
set.seed(123)

for (i in 1:10) {
  km_temp <- kmeans(cluster_data, centers = i, nstart = 20)
  wss[i] <- km_temp$tot.withinss
}

plot(1:10, wss, type = "b", pch = 19, frame = FALSE, 
     xlab = "Number of Clusters K", 
     ylab = "Total Within-Clusters Sum of Squares",
     main = "Elbow Method for Optimal k",
     col = "steelblue")


## (1) K-means clustering (k = 3)
set.seed(123)
km_k3 <- kmeans(cluster_data,
                centers = 3,
                nstart  = 20)

# Attach cluster labels back to the original data
raw_data$cluster_k3 <- factor(km_k3$cluster,
                              labels = c("Cluster 1", "Cluster 2", "Cluster 3"))

## (2) Inspect cluster centers in original units (user personas)
cluster_means <- aggregate(raw_data[ , usage_vars],
                           by   = list(Cluster = raw_data$cluster_k3),
                           FUN  = mean)
print(cluster_means)

## (3) Visualize clusters (first two dimensions: screen time vs social media)
my_colors <- c("gray30", "mediumseagreen", "indianred")

plot(cluster_data[ , 1:2],
     col  = my_colors[km_k3$cluster], 
     pch  = 20,
     cex  = 1.2,
     xlab = "Screen Time (Scaled)",
     ylab = "Social Media (Scaled)",
     main = "K-Means Clustering Results (k = 3)")

legend("bottomright",
       legend = c("Cluster 1", "Cluster 2", "Cluster 3"),
       col    = my_colors,
       pch    = 20,
       bty    = "n")