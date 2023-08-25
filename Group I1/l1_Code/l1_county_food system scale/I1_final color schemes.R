# Set up the layout for the combined plot
layout(matrix(c(1, 2, 3, 4), nrow = 4, byrow = TRUE))

# Calculate the width of each rectangle
rect_width <- 1 / (num_steps + 1)

# Create the plot for RED (Local Food Supply)
par(mar = c(4, 4, 1, 1))
plot(1, type = "n", xlim = c(0, 1), ylim = c(0, 1),
     xlab = "Grayscale Value", ylab = "Color",
     xaxt = "n", yaxt = "n", bty = "n", main = "Color Scale - Red (Local Food Supply)")

for (j in 1:length(values)) {
  # Calculate the position of the left side of each rectangle
  rect_left <- (j - 1) * rect_width
  
  # Adjust the width for the darkest shade (1st box)
  width <- ifelse(j == 1, rect_width * 1.2, rect_width)
  
  # Draw the rectangle
  rect(rect_left, 0, rect_left + width, 1, 
       col = rgb_to_hex(red_rgb_values[j, 1], red_rgb_values[j, 2], red_rgb_values[j, 3]), 
       border = NA)
}

# Create the plot for GREEN (Social Support)
par(mar = c(4, 4, 1, 1))
plot(1, type = "n", xlim = c(0, 1), ylim = c(0, 1),
     xlab = "Grayscale Value", ylab = "Color",
     xaxt = "n", yaxt = "n", bty = "n", main = "Color Scale - Green (Social Support)")

for (j in 1:length(values)) {
  # Calculate the position of the left side of each rectangle
  rect_left <- (j - 1) * rect_width
  
  # Adjust the width for the darkest shade (1st box)
  width <- ifelse(j == 1, rect_width * 1.2, rect_width)
  
  # Draw the rectangle
  rect(rect_left, 0, rect_left + width, 1, 
       col = rgb_to_hex(green_rgb_values[j, 1], green_rgb_values[j, 2], green_rgb_values[j, 3]), 
       border = NA)
}

# Create the plot for BLUE (Economics)
par(mar = c(4, 4, 1, 1))
plot(1, type = "n", xlim = c(0, 1), ylim = c(0, 1),
     xlab = "Grayscale Value", ylab = "Color",
     xaxt = "n", yaxt = "n", bty = "n", main = "Color Scale - Blue (Economics)")

for (j in 1:length(values)) {
  # Calculate the position of the left side of each rectangle
  rect_left <- (j - 1) * rect_width
  
  # Adjust the width for the darkest shade (1st box)
  width <- ifelse(j == 1, rect_width * 1.2, rect_width)
  
  # Draw the rectangle
  rect(rect_left, 0, rect_left + width, 1, 
       col = rgb_to_hex(blue_rgb_values[j, 1], blue_rgb_values[j, 2], blue_rgb_values[j, 3]), 
       border = NA)
}

# Create the plot for ORANGE (Local Food Access)
par(mar = c(4, 4, 1, 1))
plot(1, type = "n", xlim = c(0, 1), ylim = c(0, 1),
     xlab = "Grayscale Value", ylab = "Color",
     xaxt = "n", yaxt = "n", bty = "n", main = "Color Scale - Orange (Local Food Access)")

for (j in 1:length(values)) {
  # Calculate the position of the left side of each rectangle
  rect_left <- (j - 1) * rect_width
  
  # Adjust the width for the darkest shade (1st box)
  width <- ifelse(j == 1, rect_width * 1.2, rect_width)
  
  # Draw the rectangle
  rect(rect_left, 0, rect_left + width, 1, 
       col = rgb_to_hex(orange_rgb_values[j, 1], orange_rgb_values[j, 2], orange_rgb_values[j, 3]), 
       border = NA)
}

# Reset the layout
layout(1)

