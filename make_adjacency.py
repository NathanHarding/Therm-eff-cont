# -*- coding: utf-8 -*-
"""
Created on Fri Nov 10 13:02:07 2017

@author: nathan
"""
import networkx as nx
import argparse
from scipy.io import savemat as sm
parser = argparse.ArgumentParser(description='Generate graph adjacency of a watts strogatz graph to matlab file')
parser.add_argument("-k","--K", help = "k nearest neighbours for watts strogatz, results in average edges of (k-1)/2",
                    default = 7, type=int)
parser.add_argument("-p","--P_reconnect", help = "Probability of edge rewiring in watts strogatz random graph",
                    default = 1.0, type = float)
parser.add_argument("-n","--num_graphs", help = "Number of adjacency matrices to be generated",
                    default = 100, type = int)
parser.add_argument("pop", help = "Population size for the epidemic",
                    type=int)
                    
args = parser.parse_args()

population = args.pop
k = args.K
p = args.P_reconnect
for i in xrange(args.num_graphs):    
    G = nx.watts_strogatz_graph(population,k,p)
    A = nx.to_numpy_matrix(G)

    savedict = {'adjacency_matrix':A}
    sm('graph_adjacency_'+str(i),savedict)