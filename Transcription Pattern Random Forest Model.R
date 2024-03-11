# Import Library
# install.packages("randomForest")
# install.packages("ggplot2")
# install.packages("reshape2")

# Load Library
library(randomForest)
library(ggplot2)
library(reshape2)

# Generate Random Data
set.seed(123)
num_samples <- 10000

mock_data <- data.frame(
  DNA_sequence = replicate(num_samples,
                           paste(sample(c("A", "C", "G", "T"), 500,
                                        replace = TRUE), collapse = "")),
  promoter_strength = rnorm(num_samples, mean = 10, sd = 8), # Using numbers for promoter strength
  transcription_pattern = sample(c("High", "Medium", "Low"), num_samples, replace = TRUE)
)

# Prepare Data for Training and Testing
set.seed(125)
train_indices <- sample(seq_len(nrow(mock_data)), size = 0.8 * nrow(mock_data))

train_data <- mock_data[train_indices, ]
test_data <- mock_data[-train_indices, ]

train_data$transcription_pattern <- factor(train_data$transcription_pattern)
test_data$transcription_pattern <- factor(test_data$transcription_pattern)

# Train Model and Make Predictions
model <- randomForest(transcription_pattern ~ ., data = train_data)
predictions <- predict(model, newdata = test_data)

# Print Confusion Matrix and MDI
confusion_matrix <- table(predictions, test_data$transcription_pattern)

print(confusion_matrix)
print(model$importance)

# Calculate and Print Normalized Accuracy by Transcription Pattern for High/High, Medium/Medium, Low/Low
accuracies <- diag(confusion_matrix) / rowSums(confusion_matrix)
accuracies <- round(accuracies, 2)

print(paste("Accuracy for High/Medium/Low pattern:", accuracies["High"], ",", accuracies["Medium"], ",", accuracies["Low"]))

# Design Transcription Pattern Prediction Function
transcription_pattern_prediction <- function(DNA_sequence, promoter_strength) {
  if (!is.numeric(promoter_strength)) {
    stop("promoter_strength must be numeric.")
  }
  if (!is.character(DNA_sequence)) {
    stop("DNA_sequence must be a character string.")
  }
  
  input_data <- data.frame(
    DNA_sequence = DNA_sequence,
    promoter_strength = promoter_strength
  )
  
  prediction <- predict(model, newdata = input_data)
  
  return(prediction)
}

# Input DNA Sequence and Promoter Strength for Predicted Transcription Pattern
DNA_sequence <- "TGGACATGCCCTTGAAAGATATAGCAAGAGCCTGCCTGTCTATTGATGTCACGGCGAAAGTCGGGGAGACAGCAGCGGCTGCAGACATTATACCGGAACAACACTAAGGTGAGATAACTCCGTAACTGACTACGCCTTCCTCTAGACCTTACTTGACCAGATACAGTGTCTTTGACACGTTTATGGATTACAGCAATCACATCCAAGACTGGCTATGCACGAAGCAACTCTTGAGTGTTAAAATGTTGACCCCTGTATTTGGGATGCGGGTAGTAGATGACTGCAGGGACTCCGACGTCAAGTACATTACCCTCTCATAGGCGGCGTTCTAGATCACGTTACCGCCATATCATCCGAGCATGACATCATCTCCGCTGTGCCCATCCTAGTAGTCATTATTCCTATGACCCTTTTGAGTGTCCGGTGGCGGATATCCCCCACGAATGAAAATGTTTTTCGCTGACAATCATAATGGGGCGCTCCTAAGCTTTTCCACTTGG"
promoter_strength <- 8

# Calculate and Print Predicted Transcription Pattern
predicted_pattern <- transcription_pattern_prediction(DNA_sequence, promoter_strength)
print(paste("Predicted transcription pattern:", predicted_pattern))

# Calculate Normalized Accuracy by Transcription Pattern for All Entries
confusion_matrix <- table(predictions, test_data$transcription_pattern)

confusion_matrix_norm <- prop.table(confusion_matrix, 1)
confusion_matrix_norm <- round(confusion_matrix_norm, 3)

# Prepare Normalized Confusion Matrix for Plotting
confusion_matrix_melted <- melt(confusion_matrix_norm)
names(confusion_matrix_melted) <- c("PredictedLabel", "TrueLabel", "Proportion")

# Plot Normalized Confusion Matrix
confusion_matrix_plot <- ggplot(data = confusion_matrix_melted, aes(x = PredictedLabel, y = TrueLabel, fill = Proportion)) +
  geom_tile() + # Creates the heatmap blocks
  scale_fill_gradient(low = "white", high = "#CB416B") +
  theme_minimal() + # Clean theme
  labs(x = 'Predicted', y = 'True', fill = 'Proportion') +
  geom_text(aes(label = ifelse(Proportion == 0, "", Proportion)), color = "black", size = 4, na.rm = TRUE) +
  ggtitle('Normalized Confusion Matrix')

print(confusion_matrix_plot)