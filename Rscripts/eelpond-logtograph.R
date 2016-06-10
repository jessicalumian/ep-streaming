## EEL POND LOG.OUT TO ANNOTATED GRAPH
# Highlighting is specific to each run, so user will need to 
# change highlighting and text positions for each run

# Load data, name column headers
# Fill in path to file with desired path here

log.data <- read.table("~/2016-ep-streaming/output/nonstreaming/2016-02-29/log.out")
colnames(log.data) <- c("TIME", "CPU","RAM","DISK","5","6","7","8")

# Divide RAM column by 1e6 to get from bytes to MB, DISK by 1e2

log.data$RAM <- log.data$RAM/1e6
log.data$DISK <- log.data$DISK/1e2

# Plot each graph (cpu, ram, disk) separately, 
# then use grid.arrange to stack

cpuplot <- ggplot(data=log.data, aes_string(x="TIME", y="CPU")) + 
  geom_line(color = "blue") + xlab("") + ylab("CPU load (100%)") +
  ggtitle("Eel Pond Through Assembly (1-3) With Nonstreaming Algorithm on Data Subset") + theme(axis.text.x = 
  element_blank(), axis.text.y = element_text(size = 16, color = "black", 
  face = "bold"), plot.title = element_text(face = "bold", size = 13.5))

cpuploty <- cpuplot + expand_limits(y = 0)

cpuplotay <- cpuploty + annotate("text", x = 60, y = 90, label = "QC") +
  annotate("rect", xmin = 40, xmax = 80, ymin = 0, ymax = 100,
           fill = "magenta", alpha = .2) +
  annotate("text", x = 250, y = 60, label = "diginorm") +
  annotate("rect", xmin = 200, xmax = 330, ymin = 0, ymax = 100,
           fill = "purple", alpha = .2) +
  annotate("text", x =  450, y = 30, label = "assembly") +
  annotate("rect", xmin = 330, xmax = 515, ymin = 0, ymax = 100,
           fill = "orange", alpha = .2) + expand_limits(y = 0)

ramplot <- ggplot(data=log.data, aes_string(x="TIME", y="RAM")) + 
  geom_line(color = "red") + xlab("") + ylab("RAM (GB)") +
  theme(axis.text.x = element_blank(), axis.text.y = element_text(
    size = 13.5, color = "black", face = "bold"))

ramploty <- ramplot + expand_limits(y = 0)

ramplotay <- ramploty + 
  annotate("rect", xmin = 40, xmax = 80, ymin = 0, ymax = 12.5,
           fill = "magenta", alpha = .2) +
  annotate("rect", xmin = 200, xmax = 330, ymin = 0, ymax = 12.5,
           fill = "purple", alpha = .2) +
  annotate("rect", xmin = 330, xmax = 515, ymin = 0, ymax = 12.5,
           fill = "orange", alpha = .2) + expand_limits(y = 0)

diskplot <- ggplot(data=log.data, aes_string(x="TIME", y="DISK")) + 
  geom_line(color = "green") + xlab("Time (seconds)") + ylab("Disk (kTPS)") +
  theme(axis.text.x = element_text(size = 20, color = "black", 
  face = "bold"), axis.text.y = element_text(size = 13.5, 
  color = "black", face = "bold"))

diskploty <- diskplot + expand_limits(y = 0)

diskplotay <- diskploty + 
  annotate("rect", xmin = 40, xmax = 80, ymin = 0, ymax = 17,
           fill = "magenta", alpha = .2) +
  annotate("rect", xmin = 200, xmax = 330, ymin = 0, ymax = 17,
           fill = "purple", alpha = .2) +
  annotate("rect", xmin = 330, xmax = 515, ymin = 0, ymax = 17,
           fill = "orange", alpha = .2) + expand_limits(y = 0)

# for annotation: grid.arrange(cpuplotay,ramplotay,diskplotay)
# also, change annotation to proper place
grid.arrange(cpuplot,ramplot,diskplot)
