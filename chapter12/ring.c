// NOTE: This code is buggy.  It randomly deadlocks like 10% of the time!

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#ifdef DEBUG
#define DEBUG_PRINT(...) do{ fprintf( stderr, __VA_ARGS__ ); } while( 0 )
#else
#define DEBUG_PRINT(...) do{ } while ( 0 )
#endif

// N = Number of procs (threads), M = Number of times around the ring
int N = 5;
int M = 3;

int token = 0;
pthread_mutex_t token_mutex;
pthread_cond_t *token_cond;

void *wait(void *threadID)
{
    long tid;
    tid = (long)threadID;
    pthread_mutex_lock(&token_mutex);
    while (1) {
        // see if we are the last
        if (token % N == N - 1)
            M = M - 1;
        pthread_cond_wait(token_cond + tid, &token_mutex);
        if (token % N == tid) {
            DEBUG_PRINT("<%ld> received message!\n", tid);
            token++;
            pthread_cond_signal(token_cond + (token % N));
            pthread_mutex_unlock(&token_mutex);
            if (M == 0)
                break;
        }
        pthread_cond_signal(token_cond + (token % N));
    }
    DEBUG_PRINT("<%ld> Bye!\n", tid);
    pthread_exit(NULL);
}

int main(int argc, char **argv) {
    if (argc > 1 && argc == 3) {
        N = strtol(argv[1], NULL, 0);
        M = strtol(argv[2], NULL, 0);
    }
    printf("Will create %d threads and pass messages "
           "%d times around the ring (%d total)\n", N, M, N * M);

    pthread_t threads[N];
    int rc;
    long t;
    // init mutex
    pthread_mutex_init(&token_mutex, NULL);
    token_cond = malloc(sizeof(pthread_cond_t) * N);
    for (t=0; t<N; t++)
        pthread_cond_init(token_cond + t, NULL);

    // start threads
    for (t=0; t<N; t++) {
        rc = pthread_create(&threads[t], NULL, wait, (void *)t);
        if (rc) {
            printf("ERROR created pthread_create()\n");
            return(1);
        }
    }

    pthread_mutex_lock(&token_mutex);
    pthread_cond_signal(token_cond);
    pthread_mutex_unlock(&token_mutex);

    // clean up
    for (t=0; t<N; t++) {
        pthread_join(threads[t], NULL);
        pthread_cond_destroy(token_cond + t);
    }
    pthread_mutex_destroy(&token_mutex);
    pthread_exit(NULL);
    return 0;
}
