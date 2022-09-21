FROM cytopia/checkmake
COPY entrypoint.sh /lib/entrypoint.sh
RUN chmod +x /lib/entrypoint.sh
ENTRYPOINT ["/lib/entrypoint.sh"]