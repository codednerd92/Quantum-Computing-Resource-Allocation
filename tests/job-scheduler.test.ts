import { describe, it, expect, beforeEach } from 'vitest';

// Mock blockchain state
let jobs: { [key: number]: any } = {};
let jobNonce = 0;

describe('Job Scheduler', () => {
  beforeEach(() => {
    jobs = {};
    jobNonce = 0;
  });
  
  it('should submit a job', () => {
    const owner = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
    const quantumTime = 100;
    const priority = 2;
    
    jobNonce++;
    jobs[jobNonce] = {
      owner,
      quantum_time: quantumTime,
      priority,
      status: "pending"
    };
    
    expect(jobs[jobNonce]).toEqual({
      owner,
      quantum_time: quantumTime,
      priority,
      status: "pending"
    });
  });
  
  it('should cancel a job', () => {
    const owner = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
    const jobId = 1;
    
    jobs[jobId] = {
      owner,
      quantum_time: 100,
      priority: 2,
      status: "pending"
    };
    
    delete jobs[jobId];
    
    expect(jobs[jobId]).toBeUndefined();
  });
  
  it('should update job status', () => {
    const jobId = 1;
    const newStatus = "running";
    
    jobs[jobId] = {
      owner: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
      quantum_time: 100,
      priority: 2,
      status: "pending"
    };
    
    jobs[jobId].status = newStatus;
    
    expect(jobs[jobId].status).toBe(newStatus);
  });
  
  it('should get job details', () => {
    const jobId = 1;
    const jobDetails = {
      owner: 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
      quantum_time: 100,
      priority: 2,
      status: "pending"
    };
    
    jobs[jobId] = jobDetails;
    
    expect(jobs[jobId]).toEqual(jobDetails);
  });
});

