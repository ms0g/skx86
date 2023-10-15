#include "streamer.h"
#include "kheap.h"
#include "config.h"

struct disk_stream* disk_stream_new(int disk_id) {
    struct disk* disk = disk_get(disk_id);
    if (!disk) {
        return 0;
    }

    struct disk_stream* stream = kzalloc(sizeof(struct disk_stream));
    stream->pos = 0;
    stream->disk = disk;

    return stream;
}

int disk_stream_seek(struct disk_stream* stream, int pos) {
    stream->pos = pos;
    return 0;
}

int disk_stream_read(struct disk_stream* stream, void* out, int total) {
    int sector = stream->pos / SKX86_SECTOR_SIZE;
    int offset = stream->pos % SKX86_SECTOR_SIZE;

    char buf[SKX86_SECTOR_SIZE];
    int res = disk_read_block(stream->disk, sector, 1, buf);
    if (res < 0) {
        goto out;
    }

    int total_to_read = total > SKX86_SECTOR_SIZE ? SKX86_SECTOR_SIZE : total;
    for (int i = 0; i < total_to_read; i++) {
        *(char*)out++ = buf[offset + i];
    }

    stream->pos += total_to_read;
    if (total > SKX86_SECTOR_SIZE) {
        res = disk_stream_read(stream, out, total - SKX86_SECTOR_SIZE);
    }
    
out:
    return res;
}

void disk_stream_close(struct disk_stream* stream) {
    kfree(stream);
}

