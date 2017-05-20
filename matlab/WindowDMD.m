% WindowDMD is a class that implements window dynamic mode decomposition
% The time complexity (for one iteration) is O(n^2), and space complexity is 
% O(n^2), where n is the state dimension
% 
% Algorithm description:
%       At time step k, define two matrix 
%       X(k) = [x(k-w+1),x(k-w+2),...,x(k)], Y(k) = [y(k-w+1),y(k-w+2),...,y(k)], 
%       that contain the recent w snapshot pairs from a finite time window, 
%       where x(k), y(k) are the n dimensional state vector, 
%       y(k) = f(x(k)) is the image of x(k), f() is the dynamics. 
%       Here, if the (discrete-time) dynamics are given by z(k) = f(z(k-1)), then x(k), y(k)
%       should be measurements corresponding to consecutive states z(k-1) and z(k).
%       At time step k+1, we need to forget old snapshot pair xold = x(k-w+1), yold = y(k-w+1), 
%       and remember new snapshot pair xnew = x(k+1), ynew = y(k+1)
%       We would like to update the DMD matrix Ak = Yk*pinv(Xk) recursively 
%       by efficient rank-2 updating window DMD algorithm.
%        
% Usage:
%       wdmd = WindowDMD(n,w)
%       wdmd.initialize(Xq,Yq)
%       wdmd.update(xold, yold, xnew, ynew)
%       [evals, modes] = wdmd.computemodes()
%
% properties:
%       n: state dimension
%       w: finite time window size
%       timestep: number of snapshot pairs processed
%       A: DMD matrix for w snapshot pairs, size n by n
%       P: Matrix that contains information about recent w snapshots, size n by n
% 
% methods:
%       initialize(Xq, Yq), initialize window DMD algorithm
%       update(xold, yold, xnew, ynew), update by forgetting old snapshot pairs, 
%       and remeber new snapshot pair
%       At time k+1, if X(k+1) = [x(k-w+2),x(k-w+2),...,x(k+1)], Y(k+1) = [y(k-w+2),y(k-w+2),...,y(k+1)], 
%       we should take xold = x(k-w+1), yold = y(k-w+1), xnew = x(k+1), ynew = y(k+1)
%       computemodes(), compute and return DMD eigenvalues and DMD mdoes
%
% Authors: 
%   Hao Zhang
%   Clarence W. Rowley
% 
% Reference:
% Hao Zhang, Clarence W. Rowley, Eric A. Deem, and Louis N. Cattafesta,
% ``Online Dynamic Mode Decomposition for Time-varying Systems", 
% in production, 2017. Available on arXiv.
% 
% Created:
%   April 2017.
%
% To look up the documentation, type help WindowDMD

classdef WindowDMD < handle
    properties
        n = 0;              % state dimension
        w = 0;              % weighting factor
        timestep = 0;       % number of snapshots processed
        A;      % DMD matrix for w snapshot pairs, size n by n
        P;      % Matrix that contains information about recent w snapshots, size n by n
    end
    
    methods
        function obj = WindowDMD(n,w)
            % Creat an object for window DMD
            % Usage: wdmd = WindowDMD(n,w)
            if nargin == 2
                obj.n = n;
                obj.w = w;
                obj.A = zeros(n,n);
                obj.P = zeros(n,n);
            end
        end
        
        function initialize(obj, Xq, Yq)
            % Initialize WnlineDMD with q snapshot pairs stored in (Xq, Yq)
            % Usage: wdmd.initialize(Xq,Yq)
            q = length(Xq(1,:));
            if(obj.timestep == 0 && obj.w == q && obj.w >= obj.n+1)
                obj.A = Yq*pinv(Xq);
                obj.P = inv(Xq*Xq');
            end
            obj.timestep = obj.timestep + q;
        end
        
        function update(obj, xold, yold, xnew, ynew)
            
            % Update the DMD computation by sliding the finite time window forward
            % Forget the oldest pair of snapshots (xold, yold), and remebers the newest
            % pair of snapshots (xnew, ynew) in the new time window. If the new finite
            % time window at time step k+1 includes recent w snapshot pairs as
            % X(k+1) = [x(k-w+2),x(k-w+3),...,x(k+1)], Y(k+1) = [y(k-w+2),y(k-w+3),...,y(k+1)],
            % where y(k) = f(x(k)) and f is the dynamics, then we should take
            % xold = x(k-w+1), yold = y(k-w+1), xnew = x(k+1), ynew = y(k+1)
            % Usage: wdmd.update(xold, yold, xnew, ynew)
            
            % direct rank-2 update
            % define matrices
            U = [xold, xnew]; V = [yold, ynew]; C = [-1,0;0,1];
            % compute PkU matrix vector product beforehand
            PkU = obj.P*U;
            % compute AkU matrix vector product beforehand
            AkU = obj.A*U;
            % compute Gamma
            Gamma = inv(C+U'*PkU);
            % update A
            obj.A = obj.A + (V-AkU)*(Gamma*PkU');
            % update P
            obj.P = obj.P - PkU*(Gamma*PkU');
            
            % time step + 1
            obj.timestep = obj.timestep + 1;
        end
        
        function [evals, modes] = computemodes(obj)
            % Compute and return DMD eigenvalues and DMD modes at current time step
            % Usage: [evals, modes] = wdmd.computemodes()
            [modes, evals] = eig(obj.A, 'vector');
        end
    end
end