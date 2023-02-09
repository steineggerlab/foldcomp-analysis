################################################################################
# File: plotting_script.r                                                      #
# Project: visualization                                                       #
# Created: 2022-12-08 19:47:15                                                 #
# Author: Milot Mirdita (milot@mirdita.de), Hyunbin Kim (khb7840@gmail.com)    #
# Description:                                                                 #
#     This code is written as part of Foldcomp benchmark project               #
# ---                                                                          #
# Last Modified: Thu Feb 09 2023                                               #
# Modified By: Hyunbin Kim                                                     #
################################################################################
# Import libraries
library(shadowtext)
library(deeptime)
library(cowplot)
library(ggpubr)
library(reshape2)
# Colors
colorForTools <- c("pulchra"="#6B7FBB","foldcomp"="#7DBDD5","pic"="#E59A7F","gzip"="#D2E1AE", "mmtf"="#E5D7B7", "mmtf-java"="#E5D7B7","pdb"="#E5B7B7","cif"="#B7B7E5","bcif"="#B7E5B7")
order <- c("foldcomp" = "Foldcomp", "pic" = "PIC", "pulchra" = "PULCHRA", "mmtf" = "MMTF (python)", "mmtf-java" = "MMTF (java)", "gzip" = "gzip (PDB)", "bcif" = "BinaryCIF", "pdb" = "PDB", "cif" = "mmCIF")
colorForTime <- c("compression"="#6B7FBB","decompression"="#E59A7F")
colorForRMSD <- c("backboneRMSD"="#6B7FBB","totalRMSD"="#E59A7F")
# Read benchmark result
df <- read.table("data/benchmark_result.txt", header=T, sep="\t")
df <- df[which(df$tool != "gzip6"),]
df[which(df$tool=="gzip9"),]$tool <- "gzip"
df <- aggregate(time ~ pdb_path + tool + time_type, data = df, mean)
df$time <- as.numeric(df$time)
# Read size data
df_size <- read.table("data/size.txt", header=T, sep="\t")
colnames(df_size) <- c("pdb_path", "tool", "compressed_size")
df <- merge(df_size, df, by=c("pdb_path", "tool"), all.x=T)
df$size_in_kb <- df$compressed_size / 1000
df$tool <- factor(df$tool, levels=names(order))
df$time_type <- as.factor(df$time_type)
# Read rmsd data
df_rmsd <- read.table("data/rmsd.txt", header = T)
colnames(df_rmsd) <- c("pdb_path", "pdb_path_2", "backboneLen", "totalAtoms", "backboneRMSD", "totalRMSD", "tool")
df_rmsd <- subset(df_rmsd, select = -c(pdb_path_2))
df_rmsd$pdb_path <- gsub("pdb/", "", df_rmsd$pdb_path)
df_rmsd <- reshape2::melt(df_rmsd, id.vars=c("pdb_path","tool"), measure.vars=c("backboneRMSD","totalRMSD"), variable.name="rmsd_type", value.name="rmsd")
df_rmsd[which(df_rmsd$tool %in% c("pdb", "cif", "mmtf", "mmtf-java", "bcif", "gzip")),]$rmsd <- NA
df_rmsd$tool <- factor(df_rmsd$tool, levels=names(order))
df_rmsd_copy <- df_rmsd[which(df_rmsd$tool=="mmtf"),]
df_rmsd_copy$tool <- "pdb"
df_rmsd <- rbind(df_rmsd, df_rmsd_copy)
df_rmsd_copy <- df_rmsd[which(df_rmsd$tool=="mmtf"),]
df_rmsd_copy$tool <- "cif"
df_rmsd <- rbind(df_rmsd, df_rmsd_copy)
df_rmsd_copy <- df_rmsd[which(df_rmsd$tool=="mmtf"),]
df_rmsd_copy$tool <- "gzip"
df_rmsd <- rbind(df_rmsd, df_rmsd_copy)
df_rmsd_copy <- df_rmsd[which(df_rmsd$tool=="mmtf"),]
df_rmsd_copy$tool <- "mmtf-java"
df_rmsd <- rbind(df_rmsd, df_rmsd_copy)

plain <- function(x,...) {
    format(x, ..., scientific = FALSE, drop0trailing = TRUE)
}

df_time <- aggregate(time ~ tool + time_type, data = df, mean)
df_time$time_vjust <- 1
df_time[which(df_time$time_type=="compression"),]$time_vjust <- -0.6
df_time[which(df_time$time_type=="decompression"),]$time_vjust <- -0.7
# Plot
ggplot(df, aes(tool, time, color = time_type)) +
    geom_boxplot(outlier.shape=19, width=0.5, outlier.size=1, size=0.4, position=position_dodge2(1.0, preserve="single", padding=0.2)) +
    stat_summary(geom="point", fun=mean, position=position_dodge2(0.5, preserve="single")) +
    ylab("Time (s)") +
    geom_shadowtext(
        data = df_time,
        aes(tool, y=time, group=time_type, label=round(time, 3), vjust=time_vjust),
        position = position_dodge2(width = 0.5, preserve="single"),
        size=3,
        bg.colour="white",
        bg.r=0.01,
        color="black") +
    scale_x_discrete("", labels=order, drop=FALSE) +
    scale_color_manual("", values=colorForTime, labels=c("Compression", "Decompression"), drop=FALSE) +
    scale_y_continuous(breaks = c(0.0001, 0.01, 1), labels=plain) +
    coord_trans_flip(y = "log10") +
    guides(color = guide_legend(
        label.position = "left",
        label.hjust = 1)) +
    theme_cowplot() +
    theme(
        legend.position = c(0.35, 0.94),
        axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank()
    )
time_boxplot <- last_plot()

df_size <- aggregate(size_in_kb ~ tool, data = df, mean)
ggboxplot(df, x = "tool", y = "size_in_kb", color = "tool", palette = colorForTools, outlier.shape=19, width=0.25, outlier.size=1.0, add = "mean", add.params = list(size=0.15), size=0.4) +
    ylab("Size (kB)") +
    geom_text(
        data = df_size,
        aes(tool, y=size_in_kb, label=round(size_in_kb, 1)),
        size=3,
        vjust=-0.8,
        ) +
    scale_x_discrete("", labels=order) +
    scale_y_continuous(breaks = c(1, 10, 100, 1000)) +
    coord_trans_flip(y = "log10") +
    theme_cowplot() +
    theme(
        legend.position = "none"
    )
size_plot <- last_plot()

df_rmsd_mean <- aggregate(rmsd ~ tool + rmsd_type, data = df_rmsd, mean)
df_rmsd_mean$vjust <- 1
df_rmsd_mean[which(df_rmsd_mean$rmsd_type=="backboneRMSD"),]$vjust <- -0.6
df_rmsd_mean[which(df_rmsd_mean$rmsd_type=="totalRMSD"),]$vjust <- -0.7
ggboxplot(df_rmsd, x = "tool", y = "rmsd", color = "rmsd_type", palette = colorForRMSD, outlier.shape=19, width=0.5, outlier.size=1.0, add = "mean", add.params = list(size=0.15), size=0.4) +
    ylab("RMSD (Å)") +
    geom_shadowtext(
        data = df_rmsd_mean,
        aes(tool, y=rmsd, group=rmsd_type, label=round(rmsd, 2), vjust=vjust),
        position = position_dodge(width = 0.75),
        bg.colour="white",
        bg.r=0.01,
        size=3,
        color="black") +
    scale_x_discrete("", labels=order) +
    scale_y_continuous(expand = c(0.2, 0.2)) +
    scale_color_manual("", values=colorForRMSD, labels=c("Backbone", "Total")) +
    guides(color = guide_legend(
        label.position = "left",
        label.hjust = 1)) +
    coord_flip() +
    theme_cowplot() +
    theme(
        legend.position = c(0.15, 0.94),
        axis.text.y = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank()
    )
rmsd_plot <- last_plot()

grid <- plot_grid(size_plot, NA, time_boxplot, NA, rmsd_plot, rel_widths = c(0.46, -0.03, 0.33, -0.03, 0.20), nrow = 1, align = "h", axis = "h")
grid <- grid + theme(plot.margin = unit(c(0,0,0,-0.5), "cm"))
grid

# PDF
# ggsave("grid.pdf", width = 11*2, height = 4.5*2, units = "cm", bg="white")
# SVG
ggsave("grid.svg", width = 11*2, height = 4.5*2, units = "cm", bg="white")
# ggsave("grid.svg", width = 18, height = 10, units = "cm", bg="white")
ggsave("grid.png", width = 11*2, height = 4.5*2, units = "cm", bg="white")
