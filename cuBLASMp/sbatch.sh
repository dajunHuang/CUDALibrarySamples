#!/bin/bash
#SBATCH --job-name=my_a800_job
#SBATCH --partition=gpu7
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --time=4:00:00
#SBATCH --gpus-per-task=4090:1

module load cuda/12.8
module load openmpi
module load mkl/latest

echo "Job started on $(hostname)"
echo "SLURM allocated GPUs: ${CUDA_VISIBLE_DEVICES}"

mpirun --bind-to none -n 4 \
       bash -c 'export CUDA_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK; ./build/pgemm -m 10 -n 10 -k 10 -mbA 2 -nbA 2 -mbB 2 -nbB 2 -mbC 2 -nbC 2 -p 4 -q 1'

echo "Job finished"
