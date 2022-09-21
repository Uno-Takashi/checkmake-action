FROM cytopia/checkmake
RUN apk add --no-cache python3 py3-pip
COPY src /
RUN chmod +x /src/entrypoint.py
RUN chmod +x /src/CheckmakeBuilder.py
ENTRYPOINT ["python3", "/src/entrypoint.py"]