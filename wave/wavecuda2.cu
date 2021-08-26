/*
Adapted from fractal code for CS 4380 / CS 5351

Copyright (c) 2018, Texas State University. All rights reserved.

Redistribution and usage in source and binary form, with or without
modification, is only permitted for educational use.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

Author: Martin Burtscher
Revision history:
20190610   andreainfufsm   Replaced the function to calculate the color of each
pixel
*/

#include <math.h>
#include <sys/time.h>

#include <cstdlib>

#include "wave.h"

__global__ void calculateframe(int frames, int width, unsigned char* pic) {
  int index = blockIdx.x * blockDim.x + threadIdx.x;
  int stride = blockDim.x * gridDim.x;
  int N = frames * width * width;

  for (int i = index; i < N; i += stride) {
    int frame = i / (width * width);
    int idxInFrame = i % (width * width);
    int row = idxInFrame % width;
    int col = idxInFrame / width;

    float fx = col - 1024 / 2;
    float fy = row - 1024 / 2;
    float d = sqrtf(fx * fx + fy * fy);
    unsigned char color =
        (unsigned char)(160.0f + 127.0f * cos(d / 10.0f - frame / 7.0f) /
                                     (d / 50.0f + 1.0f));

    pic[i] = (unsigned char)color;
  }
}

int main(int argc, char* argv[]) {
  // check command line
  if (argc != 3) {
    fprintf(stderr, "usage: %s frame_width num_frames\n", argv[0]);
    exit(-1);
  }
  int width = atoi(argv[1]);
  if (width < 100) {
    fprintf(stderr, "error: frame_width must be at least 100\n");
    exit(-1);
  }
  int frames = atoi(argv[2]);
  if (frames < 1) {
    fprintf(stderr, "error: num_frames must be at least 1\n");
    exit(-1);
  }
  printf("computing %d frames of %d by %d picture\n", frames, width, width);

  int N = frames * width * width;
  unsigned char* pic;
  cudaMallocManaged(&pic, N);

  // start time
  timeval start, end;
  gettimeofday(&start, NULL);

  int blockSize = 256;
  int numBlocks = (N + blockSize - 1) / blockSize;
  calculateframe<<<numBlocks, blockSize>>>(frames, width, pic);
  cudaDeviceSynchronize();

  // end time
  gettimeofday(&end, NULL);
  double runtime = end.tv_sec + end.tv_usec / 1000000.0 - start.tv_sec -
                   start.tv_usec / 1000000.0;
  printf("compute time: %.4f s\n", runtime);

  // verify result by writing frames to BMP files
  if ((width <= 256) && (frames <= 100)) {
    for (int frame = 0; frame < frames; frame++) {
      char name[32];
      sprintf(name, "wave%d.bmp", frame + 1000);
      writeBMP(width, width, &pic[frame * width * width], name);
    }
  }

  cudaFree(pic);
  return 0;
}