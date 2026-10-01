FROM nginx:1.27-alpine
RUN apk add --no-cache jq
COPY run.sh /run.sh
RUN chmod +x /run.sh
CMD ["/run.sh"]
