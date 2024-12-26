# Use Nginx as the base image
FROM nginx:alpine

# Set the working directory
WORKDIR /usr/share/nginx/html

# Remove default nginx index.html
RUN rm -rf ./*

# Copy the project files into the container
COPY index.html .

# Expose port 80 to access the website
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
