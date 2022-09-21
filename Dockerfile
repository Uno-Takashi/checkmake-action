FROM cytopia/checkmake
RUN apk add --no-cache python3 py3-pip
COPY entrypoint.py /lib/entrypoint.py
RUN chmod +x /lib/entrypoint.py
ENTRYPOINT ["python3", "/lib/entrypoint.py"]