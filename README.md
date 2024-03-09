# Problem
In an in vitro transcription reaction (IVT), optimizing the promoter region and DNA sequence is an important step to optimizing the mRNA transcription pattern. In this context, transcription pattern is defined as the mRNA transcription reaction rate and quantity produced after an amount of time. Due to the complex interactions between promoter elements and other regulatory elements in a DNA sequences, it becomes difficult to decipher how interactions between DNA sequences and promoter strengths affect transcription patterns.

## DNA Promoter Regions
The promoter region is the area of a DNA sequence where an enzyme would initially bind to prepare for initiation. The promoter region is usually located up to a few dozen base pairs upstream from the gene start site--like an airplane on a runway, in an IVT reaction, an RNA polymerase enzyme recognizes and binds to the promoter region of the plasmid DNA molecule. Usually, in an IVT reaction, a strong promoter region is critical for RNA polymerase recognition and transcription initiation, and a weak promoter region risks low enzyme recognition and reduced transcription pattern.

# Solution
This code uses a random forest model to predict transcription pattern based on DNA sequence and promoter strength. For ease of computing, the promoter strength is classified into high, medium, and low.

This code was designed using a Monte Carlo simulation, so the user would need to replace the random numbers with empirical data to ensure effective model training and predictions. This code uses 10,000 DNA sequences (A/T/C/G combination of 500 bp), promoter strengths (5 ± 2 expression fold change), and transcription pattern (low/medium/high transcription). Of the 10,000 datapoints, 80% are used for training, and 20% are used for testing.

The results of this model are as follows:
1. __Confusion Matrix__: This matrix assesses the 2,000 points that were used to test the model after training with 8,000 points. When the model tested the 2,000 test points, it tallied each result into this matrix. A well-trained model maximizes the tallies in a diagonal direction (high:high, low:low, and medium:medium are the largest numbers in the matrix).
2. __MDI__: This result is the called the Mean Decrease of Impurity or the Mean Decrease Gini. Each model feature is given a score that designates its contribution to decreasing the algorithm's uncertainty, where a higher score indicates a greater contribution. These scores can be compared among features to determine relative contributions to the model's predictions.
3. __Normalized Accuracy by Transcription Pattern__: This result is derived from the confusion matrix, and it quantifies how often the model accurately predicts the transcription pattern. Since this code uses random numbers, you can expect the model to predict with ~33% accuracy, so our results are right on track! If this model were trained on empirical data, though, the accuracy would probably improve, because we'd expect the model to find data patterns.
4. __Predicted Transcription Pattern__: This result is our actual answer, because it's the result of our DNA sequence and promoter strength input.
5. __Normalized Confusion Matrix Plot__: This plot uses a sequential color palette to visualize the normalized confusion matrix. This essentially gives the same results as the normalized accuracy by transcription pattern, except this plot provides both accurate and non-accurate results.

## Empirical Datasets
To generate empirical datasets, I'd consider using the following in-lab approaches:

1. __DNA Promoter Strength__: I'd use a molecular biology technique like qPCR, ChIP-Seq, or a reporter assay and compare the expression fold change to a known reference sample.
2. __DNA Sequence__: I'd use a sequencing technique like Sangar Sequencing or NGS and import a FASTA file with all of the sequences.
3. __Transcription Pattern__: I'd use a molecular biology technique like qPCR, RNA-Seq, or Northern blotting and quantify the amount of mRNA per unit time. I've kept these units arbitrary, but the user could classify a low/medium/high transcription pattern as <50%/100%/>150% mRNA production compared to a known reference standard.
