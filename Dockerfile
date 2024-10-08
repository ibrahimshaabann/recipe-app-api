# Declare the DEV build argument
ARG DEV=false

FROM python:3.9-alpine3.13

LABEL maintainer="ibrahimshaaban"

ENV PYTHONUNBUFFERED 1

# Debug: Print the value of DEV to see if it's being passed
RUN echo "DEV is set to $DEV"

# Set up the working directory
WORKDIR /app

# Copy requirements
COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

# Install dependencies
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # Install development dependencies if DEV is true
    # if [ "$DEV" = "true" ]; then \
    #     echo "Installing development dependencies" && \
    /py/bin/pip install -r /tmp/requirements.dev.txt; \
    # else \
    #     echo "Skipping development dependencies"; \
    # fi && \
    rm -rf /tmp

# Copy the application code
COPY ./app /app

# Set up a non-root user
RUN adduser -D django-user && \
    chown -R django-user /app

# Set environment variables
ENV PATH="/py/bin:$PATH"

# Use the non-root user
USER django-user

# Expose the required port
EXPOSE 8000

# Command to run the application
CMD ["sh", "-c", "python manage.py runserver 0.0.0.0:8000"]
