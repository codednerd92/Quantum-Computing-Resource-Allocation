import { describe, it, expect, beforeEach } from 'vitest';

// Mock blockchain state
let algorithmPerformance: { [key: string]: any } = {};

describe('Performance Tracker', () => {
  beforeEach(() => {
    algorithmPerformance = {};
  });
  
  it('should record performance', () => {
    const algorithmId = 'quantum-fourier-transform';
    const runTime = 1000;
    
    algorithmPerformance[algorithmId] = {
      total_runs: 1,
      total_time: runTime,
      average_time: runTime,
      last_run_time: runTime
    };
    
    expect(algorithmPerformance[algorithmId]).toEqual({
      total_runs: 1,
      total_time: runTime,
      average_time: runTime,
      last_run_time: runTime
    });
  });
  
  it('should update performance on multiple runs', () => {
    const algorithmId = 'quantum-fourier-transform';
    const firstRunTime = 1000;
    const secondRunTime = 1200;
    
    algorithmPerformance[algorithmId] = {
      total_runs: 1,
      total_time: firstRunTime,
      average_time: firstRunTime,
      last_run_time: firstRunTime
    };
    
    const newTotalRuns = algorithmPerformance[algorithmId].total_runs + 1;
    const newTotalTime = algorithmPerformance[algorithmId].total_time + secondRunTime;
    const newAverageTime = Math.floor(newTotalTime / newTotalRuns);
    
    algorithmPerformance[algorithmId] = {
      total_runs: newTotalRuns,
      total_time: newTotalTime,
      average_time: newAverageTime,
      last_run_time: secondRunTime
    };
    
    expect(algorithmPerformance[algorithmId]).toEqual({
      total_runs: 2,
      total_time: 2200,
      average_time: 1100,
      last_run_time: 1200
    });
  });
  
  it('should get algorithm performance', () => {
    const algorithmId = 'quantum-fourier-transform';
    const performanceData = {
      total_runs: 5,
      total_time: 5000,
      average_time: 1000,
      last_run_time: 1100
    };
    
    algorithmPerformance[algorithmId] = performanceData;
    
    expect(algorithmPerformance[algorithmId]).toEqual(performanceData);
  });
});

