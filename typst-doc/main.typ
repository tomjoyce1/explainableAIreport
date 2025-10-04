//==============================================================================
// ctrsl shift p typst preview ==============================================================================

#import "@preview/abiding-ifacconf:0.2.0": *
#show: ifacconf-rules
#show: ifacconf.with(
  title: "Human-centred (HCI) xAI - Hallucinations and user trust",
  authors: (
    (
      name: "Thomas Joyce",
      email: "23367857@studentmail.ul.ie",
      affiliation: 1,
    ),
        (
      name: "Oisín Frizell",
      email: "23368276@studentmail.ul.ie",
      affiliation: 1,
    ),
        (
      name: "Andrew Jaffray",
      email: "23382163@studentmail.ul.ie",
      affiliation: 1,
    ),
        (
      name: "Edmund Phelan",
      email: "23397179@studentmail.ul.ie",
      affiliation: 1,
    ),
        (
      name: "Ruairí Glackin",
      email: "23382732@studentmail.ul.ie",
      affiliation: 1,
    )
  ),
  affiliations: (
    (
      organization: "Immersive Software Engineering, University of Limerick",
      address: "Castletroy, Limerick",
    ),
  ),
  date: "October 2025 | CS4437",

  abstract: [
    This study investigates hallucinations in Explainable AI (xAI) systems and their impact on user trust, combining theoretical analysis with empirical evaluation. Hallucinations; defined as high-confidence yet incorrect outputs, pose challenges for decision-making and can misalign user trust. We conducted a literature review to understand the underlying causes, including model stochasticity, data biases, and overgeneralization, and explored strategies for mitigating their effects through explanations and confidence indicators. Empirically, we evaluated three industry models using the HaluEval QA benchmark on 200 samples. Results show that Gemini-2.5-flash achieved 76% accuracy (152 correct), Meta-llama_Llama-3.1-8B 60% (120 correct), and DeepSeek V3.2 54% (108 correct), highlighting substantial variability in hallucination rates. Analysis indicates that hallucinations often arise from overconfident predictions and insufficient grounding in factual data, which can mislead users even when explanations are provided. These findings underscore the importance of transparent explanations and calibrated confidence measures in xAI systems to reduce trust misalignment. Overall, this work contributes to understanding the interplay between hallucinations, model performance, and user trust, offering guidance for designing more reliable and interpretable AI-assisted decision systems.
  ],
)

= Introduction
Large Language Models (LLMs) have impressive fluency and ability to perform complex tasks but a critical challenge persists: hallucinations. Hallucinations occur when models generate output that appears coherent and convincing but is factually incorrect, fabricated, or logically inconsistent (Ji et al., 2023; Maynez et al., 2020; Kazemi et al., 2023). 
Numerous studies have documented this phenomenon, highlighting its prevalence and the risks it poses in high-stakes contexts with serious consequences, such as misdiagnoses in healthcare, fabricated citations in academic writing, and erroneous case references in legal documents [1], [2].
While some research has examined how human misconceptions or biases embedded in large-scale datasets contribute to model errors, these do not strictly constitute hallucinations. Similarly, trivial multiple-choice evaluation tasks may not capture the full impact of hallucinations, which are most misleading and consequential when arising from architectural limitations.

According to Hoang et al, hallucinations in LLMs can be divided into two primary sources: 
(1) Prompting-induced hallucinations, where ill-structured, unspecified, or misleading prompts cause inefficient outputs (Reynolds and McDonell, 2021; Zhou et al., 2022; Wei et al., 2022), and (2) Model-internal hallucinations, which caused by the model's architecture, pretraining data distribution, or inference behavior (Bang and Madotto, 2023; Chen et al., 2023; OpenAI, 2023a). Distinguishing between these two causes is essential for developing effective mitigation strategies.

Currently, there is no definitive method to prevent hallucinations. While RLHF has shown promise in improving model behavior, challenges remain in ensuring the accuracy and reliability of LLM outputs. To address this issue, we are conducting a literature review to study the interaction between LLMs and hallucinations. Our research involves benchmarking 3 different LLMs. We try to reproduce findings of ? HaluEval guys’s analysis of hallucinations in large language models by using standardized hallucination evaluation benchmarks (HallucinationEval (Wu et al., 2023)).
The conclusions drawn from this analysis aim to determine whether advancements in LLMs have mitigated the occurrence of hallucinations in previously problematic scenarios, and how this impacts user trust.

#tablefig(
  placement:auto,
  table(
    columns: 1,
    align: center + horizon,
    stroke: none,
    inset: 3pt,
    [User Query : Retrieve the oldest photo of a cat],
    table.hline(),
    [("ChatGPT"):  There is no definitive answer to this question
as “the oldest photo of a cat” is subjective and varies based
on different sources and definitions. However, one can-
didate for the oldest cat photo is the daguerreotype
“Cat with Blue Ribbon,” taken by photographer Antoine
Claudet in 1840. The photo depicts a cat sitting on a table,
gazing directly at the camera, and wearing a blue ribbon
tied around its neck. [...]],  
    table.hline(),
  ),
  caption: [An example from Alpaca (Taori et al., 2023)
gpt generate hallucinated con-
tents (green) that cannot be verified by existing source.
],
) <margins>

= Benchmarking Hallucinations

==  Measuring Factuality and Harm: Standardized Benchmarks
Reliable evaluation of Large Language Models (LLMs) requires standardized, rigorous benchmarks that quantify different types of failure modes, including hallucinations, misinformation, and factual errors [1]–[3]. Hallucinations—outputs that are fluent but factually incorrect—pose serious challenges in high-stakes applications, making accurate assessment essential for both model development and user trust [1], [4], [5]. To systematically evaluate hallucination detection, we employed the HaluEval benchmark [6], which is specifically designed for QA, dialogue, and summarization tasks. HaluEval allows for precise measurement of a model’s ability to distinguish between factual and hallucinated content.
We conducted a small-scale evaluation using a subset of 200 QA items balanced between correct and hallucinated answers. Each example consisted of an instruction, a question, an answer, and a corresponding judgment label. For example:

#block(
  fill:gray.lighten(80%),
  inset: 8pt,
  radius: 8pt,

```
{
"knowledge": "Jonathan Stark (born April 3, 1971) is a former professional tennis player from the United States. During his career he won two Grand Slam doubles titles (the 1994 French Open Men's Doubles and the 1995 Wimbledon Championships Mixed Doubles). He reached the men's singles final at the French Open in 1988, won the French Open men's doubles title in 1984, and helped France win the Davis Cup in 1991.",
"question": "Which tennis player won more Grand Slam titles, Henri Leconte or Jonathan Stark?",
"answer": "Henri Leconte won more Grand Slam titles.",
"ground_truth": "Yes",
"judgement": "No"
}

```
)
This except identifies how models fail to parse truth for relatively complex logical/factual questions.

== HaluEval Analysis

Each model was prompted with the instruction and asked to determine whether the provided answer was correct, yielding a binary Yes/No judgment. Model accuracy was then computed as the proportion of judgments aligning with the ground truth, following prior evaluation methodologies [6], [7].

#tablefig(
  table(
    columns: 4,
    align: center + horizon,
    stroke: none,
    inset: 3pt,
    [Model], [Correct], [Incorrect], [Accuracy],
    table.hline(),
    [Gemini-3.5 Flash], [152], [48], [0.76],
    [Llama-3.1-8B-Instruct], [120], [80], [0.60],
    [DeepSeek V3.2 Exp], [108], [92], [0.54],
    table.hline(),
  ),
  caption: [Hallucination detection results across different LLMs using HaluEval (QA subset, 200 samples). Accuracy is the fraction of judgments matching the ground truth.],
)
Gemini-3.5 Flash (76%) demonstrated strong factual awareness and reliably acted as a hallucination detection model, making it a suitable baseline for cross-model evaluation [6], [8]. Llama-3.1-8B-Instruct (60%) performed moderately, showing inconsistency in binary judgments and suggesting potential benefit from prompt tuning with explicit Yes/No constraints [9]. DeepSeek V3.2 Exp (54%) performed barely above random guessing, indicating weak hallucination detection capabilities and low reliability as a judge model [6], [10].

These findings underscore meaningful differences in hallucination detection ability across models and reinforce the importance of rigorous benchmark evaluations. By systematically comparing model judgments against human-verified ground truth, we can quantify reliability, assess the link between explainable AI (XAI), hallucination, and trust, and identify areas where architectural or prompting interventions may improve performance [1], [4], [11].



= Hallucinations Through a Human–Centred Lens
Waiting on Ruairi's work...
== User perception of hallucinations
== Psychological and behavioral impacts
== Case studies

= xAI Strategies for Addressing Hallucinations
Waiting on Andrew's work...
== Case studies

= Trust Calibration in Human–AI Interaction
waiting on eddie
== Case studies

= Open Challenges and Research Gaps
Waiting oisin
== Case studies


See @Abl56 @AbTaRu54 @Keo58, and @Pow85.


= Conclusion

A conclusion section is not required.
Although a conclusion may review the main points of the paper, do not replicate the abstract as the conclusion.
A conclusion might elaborate on the importance of the work or suggest applications and extensions.

// Display bibliography.
#bibliography("refs.bib")

#appendix[Declarations]
== AI Declaration
Parts of this manuscript were generated or assisted by large language models, including text summarization, editing, and organization. The authors have verified the factual accuracy and intellectual content of all AI-generated material, and any errors or misrepresentations remain the responsibility of the authors. The use of AI tools does not replace critical evaluation, scholarly judgment, or original analysis.

== Equal Work
page that is signed by all group members attesting to the satisfaction that all members contributed equally to the creation of the report and that it is your own work.

Signed : Thomas Joyce, 09/10/2025 \
Signed : rg, 09/10/2025 \
Signed : ep, 09/10/2025 \
Signed : of, 09/10/2025 \
Signed : andrew, 09/10/2025
