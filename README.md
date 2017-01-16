This is a comparison of a streaming and nonstreaming versions of the [Eel Pond mRNASeq Protocol](https://khmer-protocols.readthedocs.org/en/ctb/mrnaseq/). This page contains workflows for streaming and nonstreaming algorithms of the subset of and the full set of [Nematostella data](https://darchive.mblwhoilibrary.org/handle/1912/5613) (from [Tulin et. al](http://evodevojournal.biomedcentral.com/articles/10.1186/2041-9139-4-16)).

Analysis commands:
* [Streaming, full dataset](https://github.com/dib-lab/khmer-protocols/blob/jem-streaming/mrnaseq/2-streaming-full.rst)
* Nonstreaming, full dataset [one](https://github.com/dib-lab/khmer-protocols/blob/jem-streaming/mrnaseq/3-ctb1-quality.rst), [two](https://github.com/dib-lab/khmer-protocols/blob/jem-streaming/mrnaseq/4-ctb2-diginorm.rst), [three](https://github.com/dib-lab/khmer-protocols/blob/jem-streaming/mrnaseq/5-ctb3-big-assembly.rst)
* [Streaming, subset](https://github.com/dib-lab/khmer-protocols/blob/jem-streaming/mrnaseq/1-streaming-subset.rst)
* Nonstreaming, subset [one](https://github.com/dib-lab/khmer-protocols/blob/ctb/mrnaseq/1-quality.rst), [two](https://github.com/dib-lab/khmer-protocols/blob/ctb/mrnaseq/2-diginorm.rst), [three](https://github.com/dib-lab/khmer-protocols/blob/ctb/mrnaseq/3-big-assembly.rst)

**For data subset:**

Start by firing up Amazon EC2 (m3.xlarge for data subset). Instructions on setting up an EC2 are [here](http://angus.readthedocs.org/en/2015/amazon/index.html).

**For full data set:**

Boot up an m4.4xlarge Amazon EC2. Under "Add Storage", add 600 GB on the root volume. Or, m4.large for smaller computer.

Start tmux and mount data:
```text
tmux
lsblk # lists all possible volumes, identify which is right
mkdir data/ 
sudo mount /dev/xvdf data/ # fill in correct four characters. Note- this mount replaces entire directory, so do it in an empty place
df
ls
```
Continuing on as root, start at the top of the protocols and continue on with the (non)streaming specific commands for whichever pipeline is being run.

**For both datasets:**

Install git-core for literate resting text extraction
of khmer-protocols. 

```text
sudo bash
apt-get update
chmod a+rwxt /mnt
apt-get -y install git-core python-dev python-pip python-virtualenv sysstat
```

Extract commands from protocols, note ctb branch is nonstreaming.

**For streaming (full or subset) or non streaming full data set:**
```text
cd /home/ubuntu
rm -fr literate-resting khmer-protocols
git clone https://github.com/dib-lab/literate-resting.git
git clone https://github.com/dib-lab/khmer-protocols.git -b jem-streaming

cd khmer-protocols/mrnaseq  
```

Note: For nonstreaming, data subset, do `-b ctb` instead

**For all methods:** Extract commands from protocols. 

```text
for i in [1-9]-*.rst
do
   /home/ubuntu/literate-resting/scan.py $i || break
done  
```

In another ssh session, run [sar](https://github.com/ctb/sartre) to monitor resrouces. Use screen to do so in same window. 
*Note* - ctrl+b = press control key and a at the same time, this won't copy paste.
Use [tmux](http://man.openbsd.org/OpenBSD-current/man1/tmux.1) to have multiple windows within same ssh session.

Now create a new window to run commands while tmux runs in this one:
```text
ctrl+b c
```

Start running sar:

```text
sar -u -r -d -o times.dat 1  
```
Change windows to be able to run command:

```text
crtl+b n
```

When you return to the instance, type: 
```text
tmux attach
```

**FULL DATASET (mounted manually)**

**Streaming:**

```text
bash 2-streaming-full.rst.sh
```
**Nonstreaming:**

```text
for i in [3-5]-*.rst.sh
do
   bash $i
done  
```

**DATA SUBSET**

**Streaming:**
```text
bash 1-streaming-subset.rst.sh  
```

**Nonstreaming:** (from ctb branch instead of jem-streaming)
```text
for i in [1-3]-*.rst.sh
do
   bash $i
done  
```

After pipeline finishes, use the following commands to extract disk, CPU, and RAM information from sar in corresponding screen:

```text
sar -d -p -f times.dat > disk.txt
sar -u -f times.dat > cpu.txt
sar -r -f times.dat > ram.txt
gzip *.txt
```

Use scp to transfer files to local computer (could also use cyberduck, but this is quicker). Fill in with correct paths and < > brackets. 

**Command for local computer** when in your desired file location for the assembly:

```text
scp -i ~/Downloads/amazon-streaming-current.pem ubuntu@<Public DNS>:/mnt/work/trinity_out_dir/Trinity.fasta .  
```

And also copy the times.dat and disk, cpu, and ram files to a local computer, running this same command **on the local computer**:

```text
scp -i ~/Downloads/amazon-streaming-current.pem ubuntu@<Public DNS>:/home/ubuntu/khmer-protocols/mrnaseq/times.dat .
scp -i ~/Downloads/amazon-streaming-current.pem ubuntu@<Public DNS>:/home/ubuntu/khmer-protocols/mrnaseq/*.txt.gz .  
scp -i ~/Downloads/amazon-streaming-current.pem ubuntu@<Public DNS>:/home/ubuntu/times.out .
```
In sar, do "./extract.py xvdf" to run and get log.out file (specifies disk of interest). The parsing script can be found in this repository: [https://github.com/jessicamizzi/sartre-jessica](https://github.com/jessicamizzi/sartre-jessica). Note - the sartre-jessica extract script will only work for full data sets that have been mounted. For data subsets, clone and use [https://github.com/ctb/sartre](https://github.com/ctb/sartre).

If readstats.py was run:

```text
scp -i ~/Downloads/amazon-streaming-current.pem ubuntu@e<Public DNS>:/mnt/work/readstats.out .
```

Install Transrate:
```text
cd
curl -O -L https://bintray.com/artifact/download/blahah/generic/transrate-1.0.1-linux-x86_64.tar.gz
tar xzf transrate-1.0.1-linux-x86_64.tar.gz

export PATH=$PATH:$HOME/transrate-1.0.1-linux-x86_64
echo 'export PATH=$PATH:$HOME/transrate-1.0.1-linux-x86_64' >> ~/.bashrc
export PATH=$PATH:$HOME/transrate-1.0.1-linux-x86_64/bin
echo 'export PATH=$PATH:$HOME/transrate-1.0.1-linux-x86_64/bin' >> ~/.bashrc

transrate --install-deps ref
```

Make working directory
```text
mkdir /mnt/transrate
cd /mnt/transrate
```

Copy assembly over, rename it, run sed to fix formatting problems, and run transrate
```text
cp /mnt/work/trinity_out_dir/Trinity.fasta .
sed 's_|_-_g' Trinity.fasta > Trinity.fixed.fa
transrate --assembly Trinity.fixed.fa
```
Then, download your beautiful assemblies.csv stats file!
```text
scp -i ~/Downloads/amazon-streaming-current.pem ubuntu@<Public DNS>:/mnt/transrate/transrate_results/assemblies.csv .
```

tmux commands cheat sheet:

```text
tmux
ctrl+b c # create new window
ctrl+b n # move to next window
ctrl+b p # move to previous window
tmux attach # attach back to tmux after logging back on
```
