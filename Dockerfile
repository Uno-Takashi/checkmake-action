FROM cytopia/checkmake
RUN apk add --no-cache python3 py3-pip
COPY ./src /src
RUN chmod -R +x /src
ENTRYPOINT ["python3", "/src/entrypoint.py"]