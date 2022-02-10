Notizen nächstes Meeting
========================
Brauche FTDI um Programme auf RISC_v zu flashen
known working USB blaster, digilent hs-2
pulpissimo erfolgreich geflasht



Notizen für Bakk Lösungsansatz
==============================

(Rohnotizen disregard)
Es werden keine genauen Adressen benötigt
Daten kommen in Blöcken vor die durch Branches getrennt werden; Blöcke sind ~4-5 Instruktionen lang
risc-v ist eine Load-Store architektur -> Cache misses können nur bei Loads/Stores auftreten; (können Stores auch Misses verursachen?)


Wie bekomme ich überhaupt Programme auf meinen Core??? (GRMON)


Plan:
Analyse verschiedener Umsetzungsmethoden und Probleme, wenn die Hardware nicht schnell genug ist
--> reale Datengenerierung in Echtzeitsystemen

Theoretische Behandlung von Multiprozessorsystemen

Architektur der Testplattform

Umsetzung der Testplattform

Analyse von Coremark


Interessante Fragen
===================
bei instruction mix: wieviele cyclen pro instruction type on average?

Wie kann man performance counter als Datenquelle nutzen?

Datenpunke zu erfassen: siehe Measuring Program Similarity! Nicht nur Flushes und so Zeug überwachen sondern auch Register file
Wichtig: Falls Programme in Kategorien eingeordnet und auf Ähnlichkeit überprüft werden, sind die thresholds IMMER USER DEFINED und ARBITRARY!

Kandidaten für Daten:
Instructions per block
Cycles per block
Daten aus Program similarity
Average CPI per instruction type?

Interrupt sind im Embedded wichtig!
Haben Interrupts einen Einfluss auf andere Datenpunke?

Ziel: Graphen zeichnen, die die ähnlichkeit von zwei Programmen anzeigen können, im besten Fall in "Echtzeit"

Architektur: entweder alles in Hardware und bereits verarbeitet nach außen schicken oder Daten in Hardware verarbeiten, damit Setup auch in anderen Situationen verwendet werden kann (wir werden sehen was Sinn macht; eventuell können einige Daten aus dem Debugger weiter verarbeitet werden und zu den gewünschten Daten konvertiert werden; kann auch leicht sein, dass diese Daten nicht ausreichen da source code benötigt werden würde)

Darstellung der Leistung eines Mikroprozessors in Radiusplot --> worauf normalisieren wir?

Bei der Darstellung der Daten wichtig:
sowohl Instructions als auch Cycles als Zeitachse --> Instructions blenden Instruction cache aus


Fragen die zu weit gehen
========================

Tabelle für Synth results; Critical path, gate equiv (device utilizition)
Wenn möglich für FPGA als auch standard cell? Bringt das was? 
Wahrscheinlich nicht; warum will ich performance Daten auf einem SOC auslesen? Warum sollte ich das herstellen wollen? 
--> Echtzeitfähigkeit und Benchmarking von Dependable systems
Jürgen Maier
Allerdings: Sollte es jemand machen wollen, was ist die maximale Geschwindigkeit die ich integrieren kann? Also nicht unbedingt sinnlos.
Bei Analyse von Size: welchen Core verwende ich? Wie groß ist dieser im Vergleich zu meinem Performance meter und im Vergleich zu einem realen Core?
Würde sich das Performance-meter in einem Soft-Coprozessor implementieren lassen oda wäre der Core zu schnell?

Wie verändern sich Performance-metrics von Programmen zwischen speculative, non-speculative und OOE Cores

-->Multithreaing analyse könnte interessant sein, hat auch asynchrone Events
RTOS hat auch Kontext switches

Was passiert wenn des Prozessor streaming semantics hat?


Notes for data point choice
===========================
there are data points specific to architecture and specific to software
--> not the same thing!
BUT one can be somewhat calculated from the other
this means we should split the data into two categories:
one for information about the software 
one for information about the hardware to anticipate performance

we observe the effects of multiprocessing but not multithreading!
why? on a microprocessor there will hardly be MS word. everything on that machine is important to what we want to do
there are apis on ULOS to nail down context switches to one single core - this core will *only* execute this process and nothing else; this allows for measurement of L1 cache misses. shared cache measurements are not possible.
https://github.com/stefanct/realtimeify 

ooo: what exactly does ilp mean? the actual instruction flow? how they can be dispatched?
we need two metrics: instruction stream dependency distance and maximum achievable ILP. why? we can't measure the latter in an single issue in-order machine and neither is it relevant (attention there is theoretical super scalar in order. SIMD is practically the same thing to a degree. very large instruction word CPUs do a similar thing. the compiler kind of does scheduling here. very weird look into it). however both are relevant to an out-of-order machine since the first has relevance for the depth of the look-ahead buffer and the second has relevance for SMT. BUT: how do we measure it on a machine with limited resources? (be careful with super scalar/in-out of order. not the same thing)

show data aggregation points in block diagram of R5CY and Ariane (--> auch pulp) (BOOM) since we have OOE specific data points in theory

do we need basic block size? strongly related to amount of jump operations
does basic block size always correlate to jump percentage, branch direction, ... or are there exceptions?

branch prediction: again two different metrics for different purposes. branch direction stuff is interesting for cross platform comparisons and allows miss rate calculation for simple predictors. not possible for more complex predictors; miss rate is necessary
--> for a processor with a simple predictor, miss rate is irrelevant. can be calculated from other data
(RISC-V doesn't have a delay slot. still good to mention maybe. certain programs can't use it due to dependencies)

locality measurements should allow calculation of miss rate
which windows sizes make the most sense?

what about interrupts? Basically jumps? How do we measure impact? Do we need to measure impact?

Average cycle times related to how fast certain instructions are executed but also dependent on stalls. We expect small influence of those tho. Still interesting to see if there is a large difference to what is expected. Purely academic question at this point. Low priority.

software information is not only ISA dependent but also compiler dependent!!!
measurements include all variables! change rtos, data potentially invalid.
point out limits of approach!


Data points gathered
====================

Instruction mix: computational, float, extensions, memory, branch
*average cycle count per type (for jumps strongly related to miss rate)*

= basic block size ? =

branch direction
taken branches
forward-taken branches
*prediction accuracy*

instruction stream ilp
maximum achievable ilp (ooo only)

data temporal locality
data spacial locality
instruction temporal locality
instruction spacial locality
*miss rate*
*average miss penalty*


BONUS POINTS!
=============

We should be able to construct a machine characterizer using these software metrics. We need to know IO/OOO, average execution time for each instruction type, look-ahead buffer depth, max superscalarity, branch miss delay, cache miss delay, cache depth. Given those we should be able to predict performance of certain software. (More complex than the linear model.)

If we did everything right, our software based mathematical model, our hardware data model and the seen performance should overlap. This would mean that given the software info from one artifact A and the hardware information from artifact B we should be able to calculate the performance of the target software on the target artifact!

We should also be able to calculate miss rate from our locality measurements and, for trivial predictors, branch miss rate from branching data.

For a model average delay for cache misses may make sense. In practice there are orders of magnitude difference between certain delays. (look for papers maybe) low priority
model does not work for multicore!!!
the more complex the machine, the more complex the model!! gets crazy


IMPLEMENTATION
==============

If I do a rolling average over the last 2^n instructions, i don't need to divide cus i can replace the divide with shift
At the end get final performance counter numbers and actually divide by the number of executed instructions. Does not need to be single cycle. Mark when final data is ready.
Can we get it self timed? lol

We use a shifter instead of a true divider for the final values
The realistic data needs are no more than the second digit behind the comma -> with 16-Bit Integers we can only show two digits after the comma
Assuming 750000 instructions executed as a worst case scenario, the circuit would either be able to calculate 0.015 (shifting for 1,000,000 instructions) or 0.0075 (shifting for 500,000 instructions) which is already beyond what we can show or would be relevant (talk to Stefan)