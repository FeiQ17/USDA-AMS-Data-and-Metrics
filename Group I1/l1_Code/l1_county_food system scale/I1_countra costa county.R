# Load the required libraries
library(ggplot2)
library(ggforce)

# Function to generate data points for a circle, clipped to the square
clipped_circle <- function(center_x, center_y, radius, n_points = 100, side_length) {
  angles <- seq(0, 2 * pi, length.out = n_points)
  x <- center_x + radius * cos(angles)
  y <- center_y + radius * sin(angles)
  clipped_x <- pmin(pmax(x, -side_length/2), side_length/2)
  clipped_y <- pmin(pmax(y, -side_length/2), side_length/2)
  return(data.frame(x = clipped_x, y = clipped_y))
}

# Function to generate data points for the square
square <- function(side_length) {
  x <- c(-side_length/2, side_length/2, side_length/2, -side_length/2, -side_length/2)
  y <- c(side_length/2, side_length/2, -side_length/2, -side_length/2, side_length/2)
  return(data.frame(x, y))
}

# Define the side length of the square
side_length <- 4

# Calculate the radius of the circles to extend to the adjacent corners along the edges
radius <- side_length 

# Generate data for the circles at each corner, clipped to the square
circle_data1 <- clipped_circle(-side_length/2, side_length/2, radius, side_length = side_length)
circle_data2 <- clipped_circle(side_length/2, side_length/2, radius, side_length = side_length)
circle_data3 <- clipped_circle(side_length/2, -side_length/2, radius, side_length = side_length)
circle_data4 <- clipped_circle(-side_length/2, -side_length/2, radius, side_length = side_length)

# Define the custom colors for each corner as RGB values
colors <- c("#00008B", "#006400", "#FFBB33", "#FFB6C1")  # Blue, Green, Orange, Red

# Labels for each corner
labels <- c("Economics", "Social Support", "Local Food Supply Chain", "Local Food Access")

# Plot the square and circles, and set limits to the size of the square
p <- ggplot() +
  geom_path(data = square(side_length), aes(x = x, y = y), color = "black") +
  geom_polygon(data = circle_data1, aes(x = x, y = y, fill = colors[1]), alpha = 0.8) +
  geom_polygon(data = circle_data2, aes(x = x, y = y, fill = colors[2]), alpha = 0.6) +
  geom_polygon(data = circle_data3, aes(x = x, y = y, fill = colors[3]), alpha = 0.4) +
  geom_polygon(data = circle_data4, aes(x = x, y = y, fill = colors[4]), alpha = 0.2) +
  coord_fixed() +  # Set aspect ratio to 1 to keep the plot square
  theme_void() +    # Remove axis and background
  scale_fill_identity() +  # Use colors directly without mapping to a scale
  geom_text(aes(x = -side_length/2 - 1.4, y = side_length/2, label = labels[1]), hjust = 0, vjust = 1) +
  geom_text(aes(x = side_length/2 + 1.8, y = side_length/2, label = labels[2]), hjust = 1, vjust = 1) +
  geom_text(aes(x = side_length/2 + 3, y = -side_length/2, label = labels[3]), hjust = 1, vjust = 0) +
  geom_text(aes(x = -side_length/2 - 2.3, y = -side_length/2, label = labels[4]), hjust = 0, vjust = 0) +
  ggtitle("Strength of the Food System in Contra Costa County") +   # Updated title
  theme(plot.title = element_text(hjust = 0.5))  # Center the title

print(p)
