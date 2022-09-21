FROM backplane/checkmake:latest
COPY entrypoint.sh /lib/entrypoint.sh
ENTRYPOINT ["/lib/entrypoint.sh"]