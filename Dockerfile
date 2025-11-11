FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy the requirements file
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the source code
COPY . /app

# Expose the port
EXPOSE 8100

# Command to run the application
CMD ["python", "serve.py"]